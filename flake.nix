{
  description = "Profile for Jonathan Conder";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    inherit (nixpkgs) legacyPackages lib;

    toPackages = _: pkgs: let
      texPackages = ps:
        with ps; [
          enumitem
          etoolbox
          fontawesome5
          fontspec
          hyperref
          latexmk
          luatexbase
          microtype
          noto
          stringstrings
          titlesec
          titling
          xcolor
          xkeyval
        ];

      texlive = pkgs.texliveBasic.withPackages texPackages;
    in {
      github-pages = pkgs.bundlerEnv {
        name = "github-pages-env";
        gemdir = self;
        meta.mainProgram = "github-pages";
      };

      latexmk = lib.addMetaAttrs {mainProgram = "latexmk";} texlive;
    };

    toShells = system: pkgs: let
      custom = lib.attrValues self.packages.${system};
      standard = with pkgs; [nil texlab];
    in {
      default = pkgs.mkShell {
        packages = custom ++ standard;
      };
    };
  in {
    packages = lib.mapAttrs toPackages legacyPackages;
    devShells = lib.mapAttrs toShells legacyPackages;
  };
}
