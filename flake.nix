{
  description = "Nix packages for OS/161's toolchain";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        callPackage = nixpkgs.lib.callPackageWith (
          nixpkgs.legacyPackages.${system} // self.packages.${system}
        );
      in
      rec {
        packages.os161-binutils = callPackage (import ./os161-binutils.nix) { };
        packages.os161-gcc = callPackage (import ./os161-gcc.nix) { };
        packages.os161-gdb = callPackage (import ./os161-gdb.nix) { };
        packages.sys161 = callPackage (import ./sys161.nix) { };
      }
    );
}
