# Halon for the web

An implementation of [THEME-DESIGN-GUIDE.md](../THEME-DESIGN-GUIDE.md) for web pages, the one the X-apps draw their
dashboards with. Published as `@x-tech-laboratories/halon`.

```
web/
  _tokens.css        Layer 1 — SOURCE. The token sheet, naming GTK's colours as @name.
  halon-tokens.css   GENERATED. _tokens.css with every @name filled in, light and dark.
  halon.css          Layer 2 — SOURCE. Every component rule. No colours.
  site.css           SOURCE. The insides of a page built with X-Libs' `x-libs-site`: article, outline, hero, code. No colours.
  fonts/             VENDORED. Noto Sans from Fontsource, its SIL Open Font License and the manifest the build reads.
```

`halon-tokens.css` is written by `scripts/build-web.mjs` from `_tokens.css` and the same
`gtk/Halon/shared/_tokens-*.css` that drives the other ports. The build also fails if a colour literal appears in
`halon.css` or `site.css`.

```sh
node scripts/build-web.mjs           # regenerate halon-tokens.css
node scripts/build-web.mjs --check   # fail if the output is stale
```

The colours only the web uses, the chart series, the info status and the solid fills, are literal in `_tokens.css`.

## Noto Sans

`fonts/` holds Noto Sans from [`@fontsource-variable/noto-sans`](https://fontsource.org/fonts/noto-sans), copied
unchanged: one variable file per script for upright and one for italic, each covering every weight from 100 to 900.
The scripts are Latin, Latin Extended, Vietnamese, Greek, Greek Extended, Cyrillic and Cyrillic Extended, about 730 kB
in all; a page downloads only the files for the characters it shows. Devanagari, CJK, Arabic, Hebrew and other scripts
are not bundled and use the system's fonts. `font-display: fallback` waits a moment for the bundled file, which loads
at once, so text neither flashes the fallback font nor stays hidden.

The fonts are under the [SIL Open Font License 1.1](fonts/OFL.txt), which lets them ship inside this GPL package as
separate files; the package's licence is `GPL-3.0-or-later AND OFL-1.1`. To take a newer release:

```sh
npm pack @fontsource-variable/noto-sans@<version> && tar xzf fontsource-variable-noto-sans-<version>.tgz
node scripts/vendor-fonts.mjs package    # copy the files, the licence and noto-sans.json into web/fonts/
node scripts/build-web.mjs               # rewrite the @font-face rules in halon-tokens.css
```

`build-web.mjs --check` fails when a font file no longer matches the checksum in `noto-sans.json`.

## Use

```ts
import "@x-tech-laboratories/halon/halon-tokens.css";
import "@x-tech-laboratories/halon/halon.css";
```

The dark scheme follows the system, and `data-theme="light"` or `data-theme="dark"` on `<html>` overrides it. `data-density="compact"`,
`"normal"` or `"comfortable"` on `<html>` or `.layout` sets the row height and table cell padding. The
widgets in `@x-tech-laboratories/x-libs` build the markup these rules style.

The font is Noto Sans, and it ships in this package: `halon-tokens.css` declares it from the files in `fonts/`, so a page
that imports the tokens draws in Noto Sans with no font package of its own and no network. A bundler such as Vite copies
the files into the build, and a plain `<link>` to `halon-tokens.css` finds them beside it. Text that the bundled files do
not cover falls back to the system's interface font. Code, paths and other monospace text use the system's monospace font.

`follows-host-theme` on `<html>` swaps the tokens for the colours a host page hands over as `--sidebar-*`
variables, such as the Linux sidebar. An item's own colour, such as a tag's, reaches `.chip.has-color`,
`.has-tint` and `.color-dot` through `--item-color`.

On a `body.contained` page, `fills` on one child of `main` (or of `.main-pane` beside a side pane), such as a board
under the page's heading, toolbar and a short panel, makes it take the height left and scroll by itself while the blocks
above it stay put, spaced by the gap; a wrapper between `main` and that child is marked `fills` too. The block right
under the page's heading keeps no gap above it, so the toolbar sits where it does on a page without `fills`. On a phone
(640px wide or less) nothing is held still: the blocks keep their gap but the page scrolls as a whole and the child takes
the height it needs. `.panel.compact` sits
tight around its head and rows, its head scrolling with it. A `.board` lines up with the page's heading and keeps no
margin of its own; one that is its own surface, such as a board filling a pane edge to edge, takes `inset` for a margin
inside it. A `.board-card-title` with nothing after it, or only an empty `.board-card-meta`, keeps no gap under it. A `.board-card` takes `tone-edge-bad`, `tone-edge-warn` or
`tone-edge-good` as an edge on its left in that tone, and a `.check` switch in a `.toolbar` is as tall as the controls
beside it.

## Use with the X-Libs site framework

A site built with `x-libs-site` from `@x-tech-laboratories/x-libs` is drawn in the apps' own `Shell`, so it takes the
tokens, the widget sheet and the site sheet, in that order, through its `css` setting:

```ts
css: [
  "@x-tech-laboratories/halon/halon-tokens.css",
  "@x-tech-laboratories/halon/halon.css",
  "@x-tech-laboratories/halon/site.css",
],
```

The site sheet lays out the article with its outline in a column beside it (folded above it on a narrower window), the
landing page's hero, cards, asides, the previous and next links and the sidebar's groups, each folding from an arrow before its label and linking to its own page, and colours code through
the `--shiki-*` variables Shiki's CSS-variables theme writes, so code follows the scheme.

## Publish

```sh
cd halon/web && npm publish --access public
```
