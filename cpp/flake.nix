{
  description = "devshells with flake-utils & nixpkgs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, utils }:
   utils.lib.eachSystem utils.lib.allSystems (system:
   let
     pkgs = nixpkgs.legacyPackages.${system};
   in {
     devShells = rec {
       dev = pkgs.mkShell {
         packages = with pkgs; [
          llvmPackages_21.libcxxClang
          llvmPackages_21.clang-tools
          cmake
          ninja
         ];
       };
       default = dev;
     };
   });
}
