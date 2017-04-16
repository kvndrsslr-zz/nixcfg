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

      services.taiga-back = {
        enable = true;
        databaseHost = "192.168.104.101";
      };
    };
  };

}
