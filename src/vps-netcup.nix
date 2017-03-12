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

  security.acme = {
    directory = "/var/www/challenges";
    certs = {
      "0x80.ninja" = {
        webroot = config.security.acme.directory;
        email = "admin@0x80.ninja";
        user = "nginx";
        group = "nginx";
        postRun = "systemctl restart nginx.service";
        extraDomains = {
          "gargantua1.0x80.ninja" = null;
        };
      };
    };
  };

  services.nginx = {
    enable = true;
    httpConfig = ''
    server {
      server_name gargantua1.0x80.ninja;
      listen 80;
      listen [::]:80;

      location /.well-known/acme-challenge {
         root /var/www/challenges;
      }

      location / {
        return 301 https://$host$request_uri;
      }
    }
    server {
      server_name 0x80.ninja;
      listen 443 ssl;
      ssl_certificate     ${config.security.acme.directory}/0x80.ninja/fullchain.pem;
      ssl_certificate_key ${config.security.acme.directory}/0x80.ninja/key.pem;
      root /var/www/0x80.ninja/;
    }
    server {
      server_name gargantua1.0x80.ninja;
      listen 443 ssl;
      ssl_certificate     ${config.security.acme.directory}/0x80.ninja/fullchain.pem;
      ssl_certificate_key ${config.security.acme.directory}/0x80.ninja/key.pem;
      root /var/www/gargantua1.0x80.ninja/;
    }
    '';
  };

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
