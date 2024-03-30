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
    {
      overlays.default = final: prev: {
        os161-binutils = final.callPackage (import ./os161-binutils.nix) { };
        os161-gcc = final.callPackage (import ./os161-gcc.nix) { };
        os161-gdb = final.callPackage (import ./os161-gdb.nix) { };
        sys161 = final.callPackage (import ./sys161.nix) { };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.extend self.overlays.default;
      in
      {
        packages = {
          inherit (pkgs)
            os161-binutils
            os161-gcc
            os161-gdb
            sys161
            ;
        };
      }
    );
}
