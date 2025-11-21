{
  description = "go template";

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
        godoctor = pkgs.buildGoModule (final: {
          name = "godoctor";
          src = pkgs.fetchFromGitHub {
            owner = "godoctor";
            repo = "godoctor";
            rev = "v0.8";
            hash = "sha256-RUE8lPWHLfh2KvUwlGSOdzNuJJigWctFwIwKENf3CTA=";
          };
          vendorHash = null;
          doCheck = false;
        });
      in
      {
        devShells = rec {
          dev = pkgs.mkShell {
            packages =
              with pkgs;
              [
                go
                golangci-lint
                gotests
                go-tools
                gopls
                gotools
                reftools
                gomodifytags
                gopkgs
                impl
                godef

              ]
              ++ [ godoctor ];
          };
          default = dev;
        };
      }
    );
}
