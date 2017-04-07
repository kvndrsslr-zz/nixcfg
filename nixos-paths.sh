echo "setting up paths..."
export NIX_DEV_ROOT=$HOME/nixcfg
export NIX_PKGS=$NIX_DEV_ROOT/nixpkgs
export NIX_OS=$NIX_PKGS/nixos
export NIX_OS_CONFIG=$NIX_DEV_ROOT/src/hosts/vps/default.nix
export NIX_PATH="nixpkgs=$NIX_PKGS:nixos=$NIX_OS:nixos-config=$NIX_OS_CONFIG:services=/etc/nixos/services"

echo "  NIX_PKGS=$NIX_PKGS"
echo "  NIX_OS=$NIX_OS"
echo "  NIX_OS_CONFIG=$NIX_OS_CONFIG"
echo "  NIX_PATH=$NIX_PATH"
