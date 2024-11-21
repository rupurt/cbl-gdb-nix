{
  description = "Nix flake for COBOLworx cbl-gdb";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [self.overlay];
      };
    in {
      # packages exported by the flake
      packages = rec {
        cobcd = pkgs.callPackage ./packages/cbl-gdb.nix {
          inherit pkgs;
        };
        default = cobcd;
      };

      # nix fmt
      formatter = pkgs.alejandra;
    });
  in
    outputs
    // {
      # Overlay that can be imported so you can access the packages
      # using cbl-gdb-pkgs.overlay
      overlay = final: prev: {
        cbl-gdb-pkgs = outputs.packages.${prev.system};
      };
    };
}
