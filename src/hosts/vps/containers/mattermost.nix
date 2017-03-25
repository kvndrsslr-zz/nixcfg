{ config, lib, pkgs, ... }:
let

  hostname = "mattermost";

in{

  containers."${hostname}" = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.101.100";
    localAddress = "192.168.101.101";

    bindMounts = {
      "/webroot" = { 
        hostPath = "/var/www/static-page";
        isReadOnly = true; 
        };
    };

    config = { config, pkgs, ...}: {
      networking.enableIPv6 = false;
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 80 ];
      };
      services.nginx = {
        enable = true;
        virtualHosts."${hostname}" = {
          enableSSL = false;
          root = "/webroot";
        };
      };
    };
  };

}