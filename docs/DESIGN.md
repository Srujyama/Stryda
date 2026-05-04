# Stryda — Design philosophy

This is the design system that governs every page on stryda.ai. If a
proposed change conflicts with anything below, the change is wrong.
Defaults are listed first; exceptions need a written reason.

## 1. The brief, in one sentence

Make the page look like a serious institution thought about what to put
on it, then thought longer about what to leave off.

## 2. Reference

Palantir.com. Specifically:

- One canvas color (near-black), edge to edge.
- Generous whitespace at every breakpoint.
- Information density carried by **type hierarchy** — not by cards,
  shadows, gradients, or color-coded zones.
- A single, restrained accent color used so sparingly it's an event.
- Tables and structured data, not feature grids.
- Long, declarative section copy. Few headlines. Almost no eyebrows.
- Almost no motion. No marquees, no scroll reveals on every block,
  no live "pulse" indicators, no animated demo screens.

We are not Palantir. We are imitating their **restraint**, not their
brand. We do not copy their wordmark, palette, or imagery.

## 3. Color

Pure black, period. There is no "paper" surface, no cream, no off-white
section. Sections do not change color.

| Token       | Value     | Used for                                    |
| ----------- | --------- | ------------------------------------------- |
| `--c-bg`    | `#000000` | Page canvas. Every section.                 |
| `--c-fg`    | `#FFFFFF` | Headings, primary text                      |
| `--c-fg-1`  | `#B7B7B7` | Body copy                                   |
| `--c-fg-2`  | `#7A7A7A` | Captions, eyebrows, metadata                |
| `--c-fg-3`  | `#4A4A4A` | Disabled, hairline labels                   |
| `--c-line`  | `rgba(255,255,255,0.10)` | Hairline rules, table borders  |
| `--c-line-1`| `rgba(255,255,255,0.18)` | Hover, focus, emphasis         |
| `--c-accent`| `#FFFFFF` | Primary buttons (white pill on black)       |

There is no second accent color. There is no "ok green," no "warn
amber," no "err red." If a status badly needs a non-text signal, use
the underline rule (`--c-line-1`) or position. Status verbs go in
words, not colors.

The previous design used a periwinkle accent (`#6B7BFF`). It is gone.
Do not reintroduce it.

## 4. Type

Two faces, both already loaded. No third face under any circumstance.

- **Display + body**: `Inter` (or system-ui fallback). All headings,
  all paragraph copy, all UI text. No serif on any heading.
- **Mono labels**: `IBM Plex Mono` (or `ui-monospace`). Eyebrows, table
  cells, file paths, version tags, fine print. Rare.

Heading scale (clamp on viewport, not breakpoint switches):

| Class    | Size                  | Used for                       |
| -------- | --------------------- | ------------------------------ |
| `.h-1`   | clamp(40px, 5vw, 72px)| Page hero h1                   |
| `.h-2`   | clamp(28px, 3.2vw, 44px)| Section openers              |
| `.h-3`   | clamp(20px, 2vw, 24px)| Subsection headers             |

Headings are uppercase only when they are eyebrows. Body headings are
sentence case. No italics in headings. No accent color in headings.

Paragraph: 16px on desktop, 1.65 line-height, max-width 64ch. Do not
hand-tune individual paragraph widths. Let the column do its job.

Eyebrows are mono, 11px, 0.18em letter-spacing, uppercase, color
`--c-fg-2`. One per section, max. Often the right answer is no eyebrow.

## 5. Layout

One container width: 1200px max, 24px gutter, 64px gutter at desktop.
There is no "narrow," no "wide," no "prose." One column does most of
the work. Two columns when comparing two things directly.

Section padding: 96px top and bottom. Larger only for the first
section after the nav (128–160px). Smaller never.

Sections separated by **hairline rules**, not background color shifts.
A section is a rule, then content, then a rule. No cards inside
sections unless the content is genuinely tabular.

## 6. What does NOT belong on this site

These are removed. Do not reintroduce them without writing a one-line
justification and getting it approved.

- Marquee strips.
- Animated radial glows in the hero.
- Mock product UI screens with fake live indicators.
- Reveal-on-scroll animations on every block.
- Hover-lift card grids.
- Gradient text.
- Section-color shifts (paper → dark → paper).
- Status badges in green / amber / red.
- Decorative accent dots.
- Three-column "feature card" grids with icons.
- "What happens next" step illustrations.
- Italicized words inside headlines used for emphasis.
- Two surface variants. There is only one surface.
- "v0.4 · live" version chips, "closed beta" pills, periwinkle dots,
  any other badge whose only function is to dress up the page.

## 7. What DOES belong

- Long, plain prose paragraphs.
- Hairline-ruled tables for any structured data (modules, principles,
  pricing, status, dates).
- Lists with em-dash leaders, not custom bullets.
- A small number of links (`btn` and `btn-link` only).
- Quiet section headers separated by white space.
- A single, restrained hero image or diagram per page, OR none.

## 8. Buttons

Two only:

- **`.btn`** — White pill, black text, 12px×24px, 1px radius. The
  primary CTA on the page. Use sparingly.
- **`.btn-link`** — Plain text underline, no background, no border.
  An arrow appears on hover via CSS, not in markup.

There is no ghost button, no secondary button, no tertiary button.
If you feel the need for a third button, the page has too many CTAs.

## 9. Motion

Almost none. Specifically:

- Buttons may transition `background` and `border-color` on hover.
- Links may underline on hover.
- The nav bar's hairline border may fade.

That is the entire motion budget. No reveal-on-scroll. No marquee.
No live pulse. No view-transitions.

`prefers-reduced-motion` is honored everywhere by default because
there is almost no motion to suppress.

## 10. Logo and wordmark

The mark is the three-block logo (blue / green / purple boxes
connected by a horizontal+vertical hairline). The wordmark is `stryda`
in lowercase Inter at 14px, 500 weight, sitting one space to the
right of the mark. The mark color does not change with the surface.

The mark goes top-left of the nav, top-left of the unlisted
artifact pages, and that's it. It does not appear large in the hero,
on a hero card, in a footer signature, or duplicated anywhere.

## 11. Nav

A single horizontal row, sticky to the top, hairline bottom border,
black background. No backdrop blur. No shadow.

Order: `Logo · Product · Security · About · Manifesto · Pitch · Demo (CTA)`

The unlisted pages (`/manifesto`, `/pitch`) ARE in the public nav
because the user asked for them to be reachable. They remain
`noindex` to keep them out of search, but discoverability from
the site itself is intentional.

No dropdowns. No mega-menus. No "Resources" parent. If the link
list ever exceeds seven items, delete one before adding another.

Mobile: a burger button reveals the same flat list, vertically.
Same items, same order.

## 12. Footer

Three rows, separated by hairline rules:

1. **Wordmark + one tagline sentence.** Nothing else.
2. **Two link columns.** Product. Company. No "Resources" column.
3. **Fine print.** Copyright. SF · founded 2026. That is all.

No "request a demo" callout in the footer. The CTA already lives in
the nav, the hero, and at least one in-page section.

## 13. Forms

Black inputs, hairline border, white text, no rounded corners beyond
2px. Labels are mono, uppercase, 11px, 0.16em letter-spacing.
Placeholders are `--c-fg-3`. Focus state: border lifts to `--c-fg-1`.
No accent-color focus ring.

Submit button is `.btn`. There is one submit button per form.

## 14. Tables

Hairline-ruled, not card-grouped. Top border, bottom border, one
hairline rule between every row. No striped rows. No background
color on the header row. The header row is mono, uppercase, 11px.

Tables replace 90% of the "card grid" patterns we used to write.
A table of six rows with three columns is more readable than six
cards stacked in two columns.

## 15. The unlisted pages (`/pitch`, `/manifesto`)

Same canvas, same rules, no exceptions. Long-form prose. Hairline
rules between sections. No "TL;DR card." No metrics tiles. No GTM
boxes. The reader's attention is the constraint, not visual variety.

A reader spends seven minutes on `/pitch` reading. A reader spends
seven seconds on a feature grid skimming. Choose accordingly.

## 16. When in doubt

Delete it.

If you can't decide whether a section needs an eyebrow, it doesn't.
If you can't decide whether a row needs an icon, it doesn't.
If you can't decide whether a phrase needs italic emphasis, it doesn't.

The site is a serious tool for serious people. It earns trust by
looking like it was made by someone who knows what they're doing,
not someone who knows how to use Tailwind.
