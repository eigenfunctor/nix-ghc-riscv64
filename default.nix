let
  overlays = [
    (import ./overlays/libffi.nix)
    (import ./overlays/libuv.nix)
    (import ./overlays/ghc-override.nix)
  ];

  crossSystem = (import <nixpkgs> {}).lib.systems.examples.riscv64;
in

{ pkgs ? import <nixpkgs> { inherit overlays crossSystem; } }:

with pkgs;

haskellPackages.ghc
