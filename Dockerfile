# ── Stage 1: Build the static Astro marketing site ──
FROM public.ecr.aws/docker/library/node:20-slim AS build
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci
COPY astro.config.mjs tsconfig.json ./
COPY public/ ./public/
COPY src/ ./src/
RUN npm run build

# ── Stage 2: Serve with nginx ──
FROM public.ecr.aws/nginx/nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -q -O - http://localhost:8080/ > /dev/null || exit 1

CMD ["nginx", "-g", "daemon off;"]
