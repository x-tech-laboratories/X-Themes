# Halon for the web

An implementation of [THEME-DESIGN-GUIDE.md](../THEME-DESIGN-GUIDE.md) for web pages, the one the X-apps draw their
dashboards with. Published as `@x-tech-laboratories/halon`.

```
web/
  _tokens.css        Layer 1 — SOURCE. The token sheet, naming GTK's colours as @name.
  halon-tokens.css   GENERATED. _tokens.css with every @name filled in, light and dark.
  halon.css          Layer 2 — SOURCE. Every component rule. No colours.
```

`halon-tokens.css` is written by `scripts/build-web.mjs` from `_tokens.css` and the same
`gtk/Halon/shared/_tokens-*.css` that drives the other ports. The build also fails if a colour literal appears in
`halon.css`.

```sh
node scripts/build-web.mjs           # regenerate halon-tokens.css
node scripts/build-web.mjs --check   # fail if the output is stale
```

The colours only the web uses, the chart series, the info status and the solid fills, are literal in `_tokens.css`.

## Use

```ts
import "@x-tech-laboratories/halon/halon-tokens.css";
import "@x-tech-laboratories/halon/halon.css";
```

The dark scheme follows the system, and `data-theme="light"` or `data-theme="dark"` on `<html>` overrides it. `data-density="compact"`,
`"normal"` or `"comfortable"` on `<html>` or `.layout` sets the row height and table cell padding. The
widgets in `@x-tech-laboratories/x-libs` build the markup these rules style.

`follows-host-theme` on `<html>` swaps the tokens for the colours a host page hands over as `--sidebar-*`
variables, such as the Linux sidebar. An item's own colour, such as a tag's, reaches `.chip.has-color`,
`.has-tint` and `.color-dot` through `--item-color`.

## Publish

```sh
cd halon/web && npm publish --access public
```
