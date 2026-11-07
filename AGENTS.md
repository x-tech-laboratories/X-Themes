# Instructions for AI agents

X-Themes holds the X-Tech Laboratories themes: Halon in `halon/` and the Joplin White Theme in
`joplin-white/`. Read `README.md` first, then the README of the theme you are changing.

## Setup and checks

- `nix develop` at the repository root gives the toolchain.
- `nix build .#<package>` must succeed for every package you touch; CI builds them all with `nix flake check`.
- For Halon, `nix run .#build -- --check`, `nix run .#audit` and `nix run .#lint` must pass.

## Rules

- Halon follows `halon/THEME-DESIGN-GUIDE.md`. A colour is decided in `halon/gtk/Halon/shared/_tokens-*.css`
  and nowhere else.
- Never hand-edit a generated file; change the tokens or the build script under `halon/scripts/`, then run `nix run .#build`.
- Check a visual change by rendering it (`halon-shots`, the preview commands), not only by parsing it.
- Each theme's Nix outputs live in its own `outputs.nix`; the root `flake.nix` only merges them.
- Commit messages follow Conventional Commits and end with an `Assisted-by:` trailer naming the tool.
