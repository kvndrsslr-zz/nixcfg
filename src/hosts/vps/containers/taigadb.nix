{ config, lib, pkgs, ... }:
let

  hostName = "taigadb";
  domainName = "gargantua1.0x80.ninja";
  fqdn = "${hostName}.${domainName}";

  hostAddress = "192.168.104.100";
  localAddress = "192.168.104.101";

in{
  containers."${hostName}" = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "${hostAddress}";
    localAddress = "${localAddress}";

    config = { config, pkgs, ...}: {
      networking = {
        enableIPv6 = false;

        firewall = {
          enable = true;
          allowPing = true;
          allowedTCPPorts = [
            5432 # postgres
          ];
        };
      };
      services.postgresql = {
        enable = true;
        port = 5432;
        enableTCPIP = true;

        authentication = pkgs.lib.mkForce ''
          local  all all trust
          local  all all trust
          #      database user address         auth-method
          #TODO improve 'password'
          host   all      all  127.0.0.1/32    trust
          host   all      all  ::1/128         trust
          host   all      all  192.168.103.101/32 trust
        '';
      };
    };
  };

}
