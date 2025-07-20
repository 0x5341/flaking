{
  description = "devshells with flake-utils & nixpkgs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, utils, fenix }:
    utils.lib.eachSystem utils.lib.allSystems (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ fenix.overlays.default ];
        };
      in
      {
        devShells = rec {
          dev = pkgs.mkShell {
            packages = with pkgs; [
              (fenix.fromToolchainFile {
                file = ./rust-toolchain.toml;
                sha256 = lib.fakeSha256;
              })
            ];
          };
          default = dev;
        };
      }
    );
}
