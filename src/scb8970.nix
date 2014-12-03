{ config, pkgs, ... }:

{
  imports =
    [
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
  boot.kernelParams = ["console=ttyS0,115200"];

  time.timeZone = "Europe/Moscow";

  networking.hostName = "scb8970";
  networking.useDHCP = false;
  networking.defaultGateway = "10.210.0.1";
  networking.nameservers = [ "193.105.59.2" "193.105.59.6" ];
  networking.interfaces = {
    enp9s0 = {
     ipAddress = "10.210.0.230";
     prefixLength = 16;
    };
  };

  networking.firewall.enable = false;

  services.openssh.enable = true;
  services.openssh.ports = [22 2222];
  services.openssh.permitRootLogin = "yes";

  services.ntp.enable = true;
  services.ntp.servers = [ "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];

  environment.systemPackages = with pkgs; [
    wget
    git
    vim
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

}
