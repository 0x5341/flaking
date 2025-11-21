{
  description = "devshells with flake-utils & nixpkgs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, utils, ... }:
    utils.lib.eachSystem utils.lib.allSystems (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells = rec {
          dev = pkgs.mkShell {
            packages = [ ];
          };
          default = dev;
        };
      }
    );
}
