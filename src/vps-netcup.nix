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
      };
      "gargantua1.0x80.ninja" = {
        webroot = config.security.acme.directory;
        email = "admin@0x80.ninja";
        user = "nginx";
        group = "nginx";
        postRun = "systemctl restart nginx.service";
        extraDomains = {
        };
      };
    };
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    httpConfig = ''
      server {
        server_name gargantua1.0x80.ninja;
        listen 80;

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
        ssl_certificate     ${config.security.acme.directory}/gargantua1.0x80.ninja/fullchain.pem;
        ssl_certificate_key ${config.security.acme.directory}/gargantua1.0x80.ninja/key.pem;
        root /var/www/gargantua1.0x80.ninja/;
      }
    '';
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
