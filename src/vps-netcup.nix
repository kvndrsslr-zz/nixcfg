# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

rec {
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./include/devenv.nix
    ./include/haskell.nix
    ./include/screenrc.nix
    ./include/bashrc.nix
    ./include/systools.nix
    ./include/security.nix
    ./include/postfix_relay.nix
    ./include/templatecfg.nix
    ./include/security.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  fileSystems = [
    { mountPoint = "/home";
      device = "/dev/disk/by-label/HOME";
    }
  ];

  networking.hostName = "vps";
  networking.wireless.enable = false;
  networking.firewall.enable = false;

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "lat9w-16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  programs.ssh.setXAuthLocation = true;

  services.openssh.enable = true;
  services.openssh.ports = [2222];
  services.openssh.permitRootLogin = "yes";
  services.openssh.gatewayPorts = "yes";
  services.openssh.forwardX11 = true;

  services.ntp.enable = true;
  services.ntp.servers = [ "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql92;
  };

  services.xserver.enable = false;


  services.httpd = {
    enable = true;
    adminAddr = "grrwlf@gmail.com";
    virtualHosts = [
      {
        hostName = "callback.hit.msk.ru";
        globalRedirect = "http://hit.msk.ru:8080/";
      }
      {
        hostName = "uru.hit.msk.ru";
        globalRedirect = "http://hit.msk.ru:8081/";
      }
      {
        hostName = "compet.hit.msk.ru";
        globalRedirect = "http://hit.msk.ru:8082/";
      }
      {
        hostName = "urweb.hit.msk.ru";
        globalRedirect = "http://hit.msk.ru:8083/";
      }
    ];
  };

  environment.systemPackages = with pkgs ; [
    mlton
    mercurial
    vimHugeX
    (devenv {
      name = "dev";
      extraPkgs = [ haskell710 ];
    })
    tig
    which
    postgresql
    imagemagick
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };
}
