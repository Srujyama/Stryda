#!/usr/bin/env bash
# Build, push, and roll a new ECS/Fargate revision of the Stryda service.
#
# Defaults match the live us-east-1 deployment:
#   * ECR repo            : 744574782424.dkr.ecr.us-east-1.amazonaws.com/stryda
#   * ECS cluster         : stryda
#   * ECS service         : stryda-web
#   * Task-def family     : stryda  (template in ./ecs-task-definition.json)
#   * AWS CLI v2 configured with credentials that can push ECR + update ECS.
#
# Override with env vars. Does NOT run destructive ops — worst case prints
# the AWS CLI command that failed so you can retry by hand.

set -euo pipefail

AWS_REGION="${AWS_REGION:-us-east-1}"
ACCOUNT_ID="${ACCOUNT_ID:-744574782424}"
ECR_REPO="${ECR_REPO:-stryda}"
CLUSTER="${CLUSTER:-stryda}"
SERVICE="${SERVICE:-stryda-web}"
TASK_FAMILY="${TASK_FAMILY:-stryda}"

GIT_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "manual")
IMAGE_URI="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"
IMAGE_TAG="${IMAGE_URI}:${GIT_SHA}"

echo "==> Logging in to ECR (${AWS_REGION})"
aws ecr get-login-password --region "$AWS_REGION" \
  | docker login --username AWS --password-stdin "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "==> Building image ${IMAGE_TAG}"
docker build --platform linux/amd64 -t "$IMAGE_TAG" -t "${IMAGE_URI}:latest" "$(dirname "$0")/.."

echo "==> Pushing image"
docker push "$IMAGE_TAG"
docker push "${IMAGE_URI}:latest"

echo "==> Registering new task definition revision (based on live)"
# Pull the currently-running task def, strip read-only fields, swap the
# container image to the immutable SHA tag, register the new revision.
# This avoids drift between ./ecs-task-definition.json and what's actually
# in production (CPU, memory, env vars, log config, etc).
TMP_LIVE=$(mktemp)
TMP_NEW=$(mktemp)
aws ecs describe-task-definition \
  --region "$AWS_REGION" \
  --task-definition "$TASK_FAMILY" \
  --query 'taskDefinition' > "$TMP_LIVE"

python3 - "$TMP_LIVE" "$TMP_NEW" "${IMAGE_URI}:${GIT_SHA}" <<'PY'
import json, sys
src, dst, new_image = sys.argv[1], sys.argv[2], sys.argv[3]
with open(src) as f:
    td = json.load(f)
for k in ('taskDefinitionArn', 'revision', 'status', 'requiresAttributes',
          'compatibilities', 'registeredAt', 'registeredBy', 'deregisteredAt'):
    td.pop(k, None)
# Static nginx image — no python, no /api/health, no Stripe/Firebase/Anthropic
# keys, no Secrets Manager references. Strip everything tied to the previous
# FastAPI backend so the new container can start cleanly.
for c in td.get('containerDefinitions', []):
    c['image'] = new_image
    c['environment'] = []
    c['secrets'] = []
    c['healthCheck'] = {
        'command': ['CMD-SHELL', 'wget -q -O - http://localhost:8080/ > /dev/null || exit 1'],
        'interval': 30,
        'timeout': 5,
        'retries': 3,
        'startPeriod': 10,
    }
with open(dst, 'w') as f:
    json.dump(td, f)
PY

REGISTER_OUT=$(aws ecs register-task-definition \
  --region "$AWS_REGION" \
  --cli-input-json "file://${TMP_NEW}")
rm -f "$TMP_LIVE" "$TMP_NEW"

TASK_DEF_ARN=$(printf '%s' "$REGISTER_OUT" | python3 -c "import json,sys;print(json.load(sys.stdin)['taskDefinition']['taskDefinitionArn'])")
echo "    registered: $TASK_DEF_ARN"

echo "==> Updating ECS service"
aws ecs update-service \
  --region "$AWS_REGION" \
  --cluster "$CLUSTER" \
  --service "$SERVICE" \
  --task-definition "$TASK_DEF_ARN" \
  --force-new-deployment > /dev/null

echo "==> Waiting for service to stabilize (can take a few minutes)"
aws ecs wait services-stable \
  --region "$AWS_REGION" \
  --cluster "$CLUSTER" \
  --services "$SERVICE"

echo "==> Deployed ${IMAGE_TAG}"
echo "    cluster: $CLUSTER"
echo "    service: $SERVICE"
echo "    task definition: $TASK_DEF_ARN"
