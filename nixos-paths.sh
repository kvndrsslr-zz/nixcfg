echo "setting up paths..."
export NIX_DEV_ROOT=$HOME/nixcfg
export NIXPKGS=$NIX_DEV_ROOT/nixpkgs
export NIXOS=$NIXPKGS/nixos
export NIXOS_CONFIG=$NIX_DEV_ROOT/src/hosts/vps/default.nix
export NIX_PATH="nixpkgs=$NIXPKGS:nixos=$NIXOS:nixos-config=$NIXOS_CONFIG:services=/etc/nixos/services"

echo "  NIXPKGS=$NIXPKGS"
echo "  NIXOS=$NIXOS"
echo "  NIXOS_CONFIG=$NIXOS_CONFIG"
echo "  NIX_PATH=$NIX_PATH"
