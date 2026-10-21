# White Theme

> [!WARNING]
> **This project is archived and no longer maintained.** I no longer use Joplin, so it will receive no further updates or fixes. Anyone is free to fork it and continue working on it.

A white theme for Joplin, for those of us who aren't vampires ;)

Based on https://github.com/LongBay/Joplin-Light-Theme


It has the following features:

- Uses white as much as possible (no dark or gray sidebars)
- Implemented in plugin format for quick installation
- CSS cleanup and refactoring
- Appearance configurable via settings

The homepage forum can be found here: https://discourse.joplinapp.org/t/joplin-white-theme

# Installation

- Install "White Theme" from the plugins page in joplin.
- Or, with home-manager, import `x-themes.homeManagerModules.joplin-white` from the
  [X-Themes](https://github.com/x-tech-laboratories/X-Themes) flake and set
  `themes.joplin-white.enable = true;`, which places the plugin in Joplin's plugins folder.
- Or build the plugin file with `nix build github:x-tech-laboratories/X-Themes#joplin-white-theme`
  and install `result/share/joplin/plugins/*.jpl` from Joplin's plugin settings.

# Building

`npm install` then `npm run dist` writes the plugin file to `publish/`. Webpack 4 needs
`NODE_OPTIONS=--openssl-legacy-provider` on Node 17 and later.
