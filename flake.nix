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
    let
      construct = callPackage: {
        os161-binutils = callPackage (import ./os161-binutils.nix) { };
        os161-gcc = callPackage (import ./os161-gcc.nix) { };
        os161-gdb = callPackage (import ./os161-gdb.nix) { };
        sys161 = callPackage (import ./sys161.nix) { };
      };
    in
    {
      overlays.default = final: prev: construct final.callPackage;
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        packages = construct (nixpkgs.lib.callPackageWith (pkgs // packages));
      in
      {
        inherit packages;
      }
    );
}
