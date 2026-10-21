# The Joplin White Theme's package and module; the flake at the repository root merges them in.
{ self, nixpkgs, flake-utils }:

  let
    manifest = nixpkgs.lib.importJSON ./src/manifest.json;
    pluginFile = "${manifest.id}.jpl";
  in
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages = {
        # The plugin archive Joplin installs, built by the plugin's own webpack config.
        joplin-white-theme = pkgs.buildNpmPackage {
          pname = "joplin-white-theme";
          inherit (manifest) version;
          src = nixpkgs.lib.cleanSourceWith {
            src = ./.;
            filter = path: type: !(builtins.elem (baseNameOf path) [ "node_modules" "dist" "publish" ]);
          };
          npmDepsHash = "sha256-mPcxT/Thj0+0Wz5gWuhINOplUpiVrlit5fH4J7zqjCA=";
          npmBuildScript = "dist";
          # Webpack 4 hashes with MD4, which current OpenSSL only offers through its legacy provider.
          env.NODE_OPTIONS = "--openssl-legacy-provider";
          installPhase = ''
            runHook preInstall
            install -Dm644 "publish/${pluginFile}" "$out/share/joplin/plugins/${pluginFile}"
            runHook postInstall
          '';
          passthru = { inherit pluginFile; };
          meta = {
            description = "A white theme for Joplin, as a plugin with configurable accent, sizes and fonts";
            license = nixpkgs.lib.licenses.gpl3Only;
          };
        };
      };
    }) // {
    # home-manager: `imports = [ x-themes.homeManagerModules.joplin-white ];  themes.joplin-white.enable = true;`
    homeManagerModules.joplin-white = { config, lib, pkgs, ... }:
      let
        cfg = config.themes.joplin-white;
        pkg = self.packages.${pkgs.stdenv.hostPlatform.system}.joplin-white-theme;
      in {
        options.themes.joplin-white = {
          enable = lib.mkEnableOption "the White Theme plugin for Joplin desktop";
          profileDir = lib.mkOption {
            type = lib.types.str;
            default = ".config/joplin-desktop";
            description = "The Joplin profile directory, relative to home, whose plugins folder gets the theme.";
          };
        };
        config = lib.mkIf cfg.enable {
          home.file."${cfg.profileDir}/plugins/${pluginFile}".source =
            "${pkg}/share/joplin/plugins/${pluginFile}";
        };
      };
  }
