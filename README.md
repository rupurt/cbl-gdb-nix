# cbl-gdb-nix

Nix flake to build COBOLworx [cbl-gdb](https://gitlab.cobolworx.com/COBOLworx/cbl-gdb)
debugging extensions to GnuCOBOL on Linux & MacOS.

## Usage

```nix
{
  description = "Your nix flake with cbl-gdb. Hack the planet!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    cbl-gdb {
      url = "github:rupurt/cbl-gdb-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    flake-utils,
    cbl-gdb,
    nixpkgs,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        overlays = [
          cbl-gdb.overlay
        ];
      };
    in {
      # nix fmt
      formatter = pkgs.alejandra;

      # nix develop -c $SHELL
      devShells.default = pkgs.mkShell {
        name = "default dev shell";

        packages = with pkgs; [
          cbl-gdb-pkgs.cbl-gdb
        ];
      };
    });
  in
    outputs;
}
```
