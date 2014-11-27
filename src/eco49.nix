# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
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
     subnetMask = "255.255.0.0"; 
    };
  };

  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  services.openssh.enable = true;

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
  ];

}
