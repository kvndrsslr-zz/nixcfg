{ config, lib, pkgs, ... }:
let

  hostName = "taiga";
  domainName = "gargantua1.0x80.ninja";
  fqdn = "${hostName}.${domainName}";

  hostAddress = "192.168.103.100";
  localAddress = "192.168.103.101";
in{

  containers."${hostName}" = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "${hostAddress}";
    localAddress = "${localAddress}";

    config = { config, pkgs, ...}: {
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 80 ];
      };

      services.taiga = {
        enable = true;
        inherit fqdn;
        database.host = "192.168.104.101";
        front = {
          apiUrl = "https://${fqdn}/api/v1";
        };
      };
    };
  };

  services.nginx.virtualHosts."${fqdn}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://${localAddress}";
    };
  };

}
