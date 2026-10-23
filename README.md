# X-Themes

The X-Tech Laboratories themes, in one repository with one Nix flake.

| Theme | Folder | What it covers |
| --- | --- | --- |
| Halon | [halon/](halon/) | A slate and blue desktop theme, light and dark, for GTK 3/4, Cinnamon, Qt, icons, Firefox, VS Code, Steam, Trilium, Tilix, LMMS, LightDM and Plymouth |
| White Theme | [joplin-white/](joplin-white/) | A white theme for Joplin desktop, as a plugin |

Each folder keeps its own README with the details for that theme, and its full history.

## Building

```sh
nix build .#all                  # every theme and every variant, in ./result
nix build .#halon-theme          # one package
nix build .#joplin-white-theme   # the Joplin plugin file
nix flake show                   # the full list
```

| Package | Variants it holds |
| --- | --- |
| `halon-theme` | GTK and Cinnamon `Halon` and `Halon-Dark` |
| `halon-icon-theme` | icons `Halon` and `Halon-Dark` |
| `halon-qt-theme` | qt5ct and qt6ct colour schemes and style sheets, light and dark |
| `halon-vscode-theme` | `Halon Light` and `Halon Dark` |
| `halon-firefox-theme` | one theme that follows the system scheme |
| `halon-steam-theme` | Millennium theme, light and dark schemes |
| `halon-trilium-theme` | Trilium CSS note, both schemes |
| `halon-tilix-theme` | `Halon` and `Halon-Dark` terminal schemes |
| `halon-lmms-theme` | `Halon` (dark) and `Halon-Light` |
| `halon-lightdm-theme` | web-greeter login screen |
| `halon-plymouth-theme` | boot splash |
| `halon-tokens` | both schemes' colours as JSON |
| `joplin-white-theme` | Joplin plugin, configured from Joplin's settings |

## Installing

Add the flake as an input:

```nix
inputs.x-themes.url = "github:x-tech-laboratories/X-Themes";
```

On NixOS, install the Halon GTK and icon themes system-wide:

```nix
imports = [ x-themes.nixosModules.halon ];
themes.halon.enable = true;
```

With home-manager, `homeManagerModules.default` brings every theme's options, each off until enabled:

```nix
imports = [ x-themes.homeManagerModules.default ];

themes.halon.enable = true;          # GTK, Cinnamon shell and icons, selected as the defaults
themes.halon.qt = true;              # Qt through qt5ct/qt6ct; also set qt.platformTheme
themes.halon.qtScheme = "dark";      # "light" or "dark"
themes.halon.lmms = true;            # LMMS

themes.joplin-white.enable = true;   # the Joplin plugin, in ~/.config/joplin-desktop/plugins
```

To install a single package without a configuration:

```sh
nix profile install github:x-tech-laboratories/X-Themes#halon-vscode-theme
```

Without Nix, each port is plain files; follow the install section in that port's README.

## Working on it

```sh
nix develop    # or `direnv allow`
```

The shell carries Halon's build, audit, lint and preview commands, listed when it starts. CI builds
every package and checks that Halon's generated files still match its tokens.

## Licence

GPL-3.0. See [LICENSE](LICENSE), and the LICENSE file in each theme's folder.
