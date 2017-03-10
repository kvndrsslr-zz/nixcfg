# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  my_ssh_port = 2222;
in
rec {
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./include/user-betaboon.nix
    ./include/ntpd.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking = {
    hostName = "gargantua1";
    wireless.enable = false;
    firewall.enable = false;
  };

  programs.ssh.setXAuthLocation = true;

  services.openssh = {
    enable = true;
    ports = [ my_ssh_port ];
    permitRootLogin = "yes";
    gatewayPorts = "yes";
    forwardX11 = true;
  };

  services.xserver.enable = false;
  
  environment.systemPackages = with pkgs ; [
    vim
  ];

  nixpkgs.config = {
    allowUnfree = false;
  };
}
