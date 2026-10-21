{
  description = "X-Themes — the X-Tech Laboratories themes: Halon for the desktop and its apps, and White Theme for Joplin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      halon = import ./halon/outputs.nix { inherit self nixpkgs flake-utils; };
      joplin-white = import ./joplin-white/outputs.nix { inherit self nixpkgs flake-utils; };

      # One theme's outputs never share a name with another's, so a deep merge only combines them.
      merged = nixpkgs.lib.recursiveUpdate halon joplin-white;
    in
    nixpkgs.lib.recursiveUpdate merged ({
      nixosModules.default = self.nixosModules.halon;

      # Every theme's options, each off until enabled.
      homeManagerModules.default = {
        imports = [ self.homeManagerModules.halon self.homeManagerModules.joplin-white ];
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        packages = self.packages.${system};
      in
      {
        packages = {
          # Every theme and every variant in one install, for trying them all.
          all = pkgs.symlinkJoin {
            name = "x-themes";
            paths = with packages; [
              halon-theme halon-icon-theme halon-qt-theme halon-vscode-theme halon-firefox-theme
              halon-steam-theme halon-trilium-theme halon-tilix-theme halon-lmms-theme
              halon-lightdm-theme halon-plymouth-theme halon-tokens joplin-white-theme
            ];
          };
          default = packages.halon-theme;
        };
        apps.default = self.apps.${system}.audit;

        # Building every package is the check, since each one is a theme variant someone installs.
        checks = builtins.removeAttrs packages [
          "default" "all" "preview-gtk3" "preview-gtk4" "demo-gtk3" "demo-gtk4" "demo-adwaita"
          "icons-gtk3" "preview-lightdm" "preview-lmms" "audit" "lint" "build" "shots" "shots-lightdm"
        ];
      }));
}
