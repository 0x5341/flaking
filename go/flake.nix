{
  description = "go template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, utils, ... }:
    utils.lib.eachSystem utils.lib.allSystems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      ci-pkgs = with pkgs; [ go golangci-lint gotests ];
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
      dev-pkgs = (
        with pkgs; [ gopls gotools reftools gomodifytags gopkgs impl godef ]
      ) ++ [ godoctor ];
    in {
      devShells = rec {
        dev = pkgs.mkShell {
          packages = ci-pkgs ++ dev-pkgs;
        };
        ci = pkgs.mkShell {
          packages = ci-pkgs;
        };
        default = dev;
      };
    });
}
