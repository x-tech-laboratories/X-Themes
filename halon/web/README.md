# Halon for the web

An implementation of [THEME-DESIGN-GUIDE.md](../THEME-DESIGN-GUIDE.md) for web pages, the one the X-apps draw their
dashboards with. Published as `@x-tech-laboratories/halon`.

```
web/
  _tokens.css        Layer 1 — SOURCE. The token sheet, naming GTK's colours as @name.
  halon-tokens.css   GENERATED. _tokens.css with every @name filled in, light and dark.
  halon.css          Layer 2 — SOURCE. Every component rule. No colours.
  starlight.css      SOURCE. Maps the tokens onto Astro Starlight's variables, for the X-apps' documentation sites. No colours.
  site.css           SOURCE. The insides of a page built with X-Libs' `x-libs-site`: article, outline, hero, code. No colours.
```

`halon-tokens.css` is written by `scripts/build-web.mjs` from `_tokens.css` and the same
`gtk/Halon/shared/_tokens-*.css` that drives the other ports. The build also fails if a colour literal appears in
`halon.css`, `starlight.css` or `site.css`.

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

The font is Noto Sans, falling back to the system's interface font. Bundle it with the page so it shows where it is not
installed, in the weights the sheets use:

```ts
import "@fontsource/noto-sans/400.css";
import "@fontsource/noto-sans/500.css";
import "@fontsource/noto-sans/600.css";
import "@fontsource/noto-sans/700.css";
```

`follows-host-theme` on `<html>` swaps the tokens for the colours a host page hands over as `--sidebar-*`
variables, such as the Linux sidebar. An item's own colour, such as a tag's, reaches `.chip.has-color`,
`.has-tint` and `.color-dot` through `--item-color`.

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
landing page's hero, cards, asides, the previous and next links and the sidebar's folding groups, and colours code through
the `--shiki-*` variables Shiki's CSS-variables theme writes, so code follows the scheme.

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
