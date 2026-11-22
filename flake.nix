{
  description = "Poisonbloom color theme";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
  };

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "aarch64-darwin"
          "aarch64-linux"
          "x86_64-linux"
        ] (system: function nixpkgs.legacyPackages.${system});
    in
    {
      lib.themes = {
        bat = ./themes/bat;
        delta = ./themes/delta/poisonbloom.gitconfig;
        ghostty = ./themes/ghostty;
        nvim = ./themes/nvim/palette.lua;
        yazi = {
          poisonbloom-dark = ./themes/yazi/poisonbloom-dark.yazi;
          poisonbloom-light = ./themes/yazi/poisonbloom-light.yazi;
        };
        zed = ./themes/zed/poisonbloom.json;
      };

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = [ pkgs.catppuccin-whiskers ];
        };
      });

      checks = forAllSystems (pkgs: {
        generated =
          pkgs.runCommand "check-generated" { nativeBuildInputs = [ pkgs.catppuccin-whiskers ]; }
            ''
              cp --recursive --no-preserve=mode ${self} source
              bash source/generate.sh
              diff --recursive ${self} source
              touch "$out"
            '';
      });
    };
}
