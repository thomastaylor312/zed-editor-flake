{
  description = "A flake providing an up-to-date package for zed-editor";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    patched-nixpkgs.url = "github:TomaSajt/nixpkgs?ref=fetch-cargo-vendor-dup";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    patched-nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} (
      {
        withSystem,
        moduleWithSystem,
        flake-parts-lib,
        ...
      }: {
        systems = with nixpkgs.lib.platforms; linux ++ darwin;

        perSystem = {
          system,
          pkgs,
          self',
          inputs',
          ...
        }: {
          packages = {
            zed-editor = pkgs.callPackage ./packages/zed-editor {
              rustPlatform = inputs'.patched-nixpkgs.legacyPackages.rustPlatform;
            };
            zed-editor-fhs = self'.packages.zed-editor.passthru.fhs;

            zed-editor-bin = pkgs.callPackage ./packages/zed-editor-bin {};
            zed-editor-bin-fhs = self'.packages.zed-editor-bin.passthru.fhs;

            default = self'.packages.zed-editor;
          };

          apps = {
            zed-editor.program = "${self'.packages.zed-editor}/bin/zeditor";
            zed-editor-fhs.program = "${self'.packages.zed-editor-fhs}/bin/zeditor";
            zed-editor-bin.program = "${self'.packages.zed-editor-bin}/bin/zeditor";
            zed-editor-bin-fhs.program = "${self'.packages.zed-editor-bin-fhs}/bin/zeditor";
          };
        };
      }
    );
}
