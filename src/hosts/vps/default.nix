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
    ../../users/betaboon.nix
    ../../services/ntpd.nix
    ../../programs/zsh.nix
    ./services/nginx.nix
#   ./containers/nameserver.nix    # TODO setup unbound
#   ./containers/reverse-proxy.nix # TODO move nginx to container
    ./containers/test.nix          # nginx serving static
    ./containers/mattermost.nix    # TODO setup mattermost
#   ./containers/nextcloud.nix     # TODO setup nextcloud
#   ./containers/taiga.nix         # TODO setup taiga
#   ./containers/znc.nix           # TODO setup znc
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking = {
    enableIPv6 = false;
    wireless.enable = false;
    hostName = "gargantua1";
    domain = "0x80.ninja";
    search = [ "0x80.ninja" "gargantua1.0x80.ninja" ];
    # server-list: http://servers.opennicproject.org/
    # using opennic-servers with the following qualities:
    # - close to our location
    # - LogAnon + !Whitelist + DNScrypt
    # TODO configure dnscrypt
    nameservers = [ "130.255.73.90" ];

    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 my_ssh_port ];
      allowPing = false;
      logRefusedConnections = true;
    };

    nat = {
      enable = false;
      externalInterface = "enp0s3";
      forwardPorts = [];
    };
  };

  programs.ssh.setXAuthLocation = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  services.xserver.enable = false;
  services.openssh = {
    enable = true;
    ports = [ my_ssh_port ];
    permitRootLogin = "no";
  };

  environment.systemPackages = with pkgs ; [
    vim
    tig
    htop
    lsof
    strace
    nmap
    tcpdump
    iftop
  ];

  nixpkgs.config = {
    allowUnfree = false;
  };
}
