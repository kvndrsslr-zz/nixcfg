echo "setting up paths..."
export NIX_DEV_ROOT=$HOME/nixcfg
export NIX_HOST_CONFIG=$NIX_DEV_ROOT/src/hosts/vps/default.nix
export NIX_PATH="nixpkgs=$NIX_DEV_ROOT/nixpkgs:nixos=$NIX_DEV_ROOT/nixpkgs/nixos:nixos-config=$NIX_HOST_CONFIG:services=/etc/nixos/services"

echo "  NIX_DEV_ROOT=$NIX_DEV_ROOT" 
echo "  NIX_HOST_CONFIG=$NIX_HOST_CONFIG"
echo "  NIX_PATH=$NIX_PATH"
