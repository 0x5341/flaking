{
  description = "flaking: nix-flake templates for spacemacs";

  outputs = { ... }: {
    templates = {
      devshells = {
        path = ./devshells;
        description = "DevShells (use flake-utils)";
      };
      go = {
        path = ./go;
        description = "Go Environment for spacemacs";
      };
      rust = {
        path = ./rust;
        description = "Rust Environment";
      };
      cpp = {
        path = ./cpp;
        description = "C++ Environment with clang, cmake, ninja";
      };
    };
  };
}
