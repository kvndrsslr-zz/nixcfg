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
    enableIPv6 = false;
    wireless.enable = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 my_ssh_port ];
      allowPing = false;
      logRefusedConnections = true;
    };
  };

  programs.ssh.setXAuthLocation = true;

  services.xserver.enable = false;
  services.openssh = {
    enable = true;
    ports = [ my_ssh_port ];
    permitRootLogin = "yes";
    gatewayPorts = "yes";
    forwardX11 = true;
  };

#  services.httpd = {
#    enable = true;
#    enableSSL = false;
#    logPerVirtualHost = true;
#    adminAddr = "admin@0x80.ninja";
#    virtualHosts = [
#      {
#        hostName = "gargantua1.0x80.ninja";
#        serverAliases = [ "gargantua1.0x80.ninja" ];
#        documentRoot = "/www";
#        extraConfig = ''
#          ErrorDocument 404 /404.html
#          ErrorDocument 500 /500.html
#        '';
#      }
#    ];
#  };
    enable = true;

  services.postgresql = {
    enable = false;
  };

  services.mattermost = {
    enable = false;
    siteUrl = "http://mattermost.0x80.ninja";
    siteName = "mattermost";
  };

  environment.systemPackages = with pkgs ; [
    vim
    tig
    htop
    tcpdump
    lsof
    strace
  ];

  nixpkgs.config = {
    allowUnfree = false;
  };
}
