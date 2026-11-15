# Halon for the web

An implementation of [THEME-DESIGN-GUIDE.md](../THEME-DESIGN-GUIDE.md) for web pages, the one the X-apps draw their
dashboards with. Published as `@x-tech-laboratories/halon`.

```
web/
  _tokens.css        Layer 1 — SOURCE. The token sheet, naming GTK's colours as @name.
  halon-tokens.css   GENERATED. _tokens.css with every @name filled in, light and dark.
  halon.css          Layer 2 — SOURCE. Every component rule. No colours.
  starlight.css      SOURCE. Maps the tokens onto Astro Starlight's variables, for the X-apps' documentation sites. No colours.
```

`halon-tokens.css` is written by `scripts/build-web.mjs` from `_tokens.css` and the same
`gtk/Halon/shared/_tokens-*.css` that drives the other ports. The build also fails if a colour literal appears in
`halon.css` or `starlight.css`.

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

## Use with Starlight

An [Astro Starlight](https://starlight.astro.build) site takes the tokens and the Starlight sheet, not `halon.css`:

```js
starlight({
  customCss: [
    "@x-tech-laboratories/halon/halon-tokens.css",
    "@x-tech-laboratories/halon/starlight.css",
  ],
});
```

The sheet sets Halon's sizes as well as its colours: the 49px top bar with the site's name in a cell above the
sidebar, the 248px sidebar of 13px tree rows under small caps section labels, the 14px prose with Halon's heading scale,
and the page's contents as a side pane. The page you are on is a raised card in the sidebar. Starlight's theme picker
drives the scheme through the same `data-theme` attribute.

## Publish

```sh
cd halon/web && npm publish --access public
```
