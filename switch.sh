#!/bin/sh

export NIX_DEV_ROOT=/home/grwlf/proj/nixcfg
export NIX_PATH="nixpkgs=$NIX_DEV_ROOT/nixpkgs:nixos=$NIX_DEV_ROOT/nixpkgs/nixos:nixos-config=$NIX_DEV_ROOT/src/samsung-np900x3c.nix:services=/etc/nixos/services:passwords=$NIX_DEV_ROOT/pass"

nixos-rebuild switch
