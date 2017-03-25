{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  
  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xlibs // self);
  
  self = {
    pkgconfig = callPackage ../nixpkgs/pkgs/development/tools/misc/pkgconfig { };
  
    taiga-back = callPackage ./pkgs/taiga/taiga-back.nix { };
    taiga-front = callPackage ./pkgs/taiga/taiga-front.nix { };
  };
in
self
