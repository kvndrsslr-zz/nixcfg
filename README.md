Setting up the environment
==========================

Export the Nix paths via the NIX\_PATH variable

    export NIX_DEV_ROOT=$HOME/nixcfg
    export NIX_PATH="nixpkgs=$NIX_DEV_ROOT/nixpkgs:nixos=$NIX_DEV_ROOT/nixpkgs/nixos:nixos-config=$NIX_DEV_ROOT/src/vps-netcup.nix:services=/etc/nixos/services"

