{ config, lib, pkgs, ... }:
let

  hostName = "test";
  domainName = "gargantua1.0x80.ninja";
  fqdn = "${hostName}.${domainName}";

  hostAddress = "192.168.100.100";
  localAddress = "192.168.100.101";

in{

  services.nginx.virtualHosts."${fqdn}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://${localAddress}";
    };
  };

  containers."${fqdn}" = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "${hostAddress}";
    localAddress = "${localAddress}";

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
        virtualHosts."${fqdn}" = {
          enableSSL = false;
          root = "/webroot";
        };
      };
    };
  };

}
