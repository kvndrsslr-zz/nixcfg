# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  imports = [
      /etc/nixos/hardware-configuration.nix
      ./include/devenv.nix
      ./include/screenrc.nix
      ./include/bashrc.nix
      ./include/systools.nix
      ./include/security.nix
      ./include/templatecfg.nix
      ./include/workusers.nix
      <nixos/modules/programs/virtualbox.nix>
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "eco49";
  networking.useDHCP = false;
  networking.defaultGateway = "10.210.0.1";
  networking.nameservers = [ "8.8.8.8" ];
  networking.interfaces = {
    enp4s0 = {
     ipAddress = "10.210.0.49";
     prefixLength = 16;
    };
  };

  networking.firewall.enable = false;

  # Europe/Moscow
  time.timeZone = "Europe/Moscow";

  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  services.ntp.enable = true;
  services.ntp.servers = [ "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];

  services.openssh.enable = true;
  services.openssh.ports = [22 2222];
  services.openssh.permitRootLogin = "yes";

  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql92;

  services.xserver.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   name = "guest";
  #   group = "users";
  #   uid = 1000;
  #   createHome = true;
  #   home = "/home/guest";
  #   shell = "/run/current-system/sw/bin/bash";
  # };

  # List packages installed in system profile. To search by name, run:
  # -env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    git
    vimHugeX
    minicom
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

}
