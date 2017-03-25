{ config, lib, pkgs, ... }:
let

  hostname = "mattermost";

in{

  containers."${hostname}" = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.101.100";
    localAddress = "192.168.101.101";

    config = { config, pkgs, ...}: {
      networking.enableIPv6 = false;
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [
          8065 # mattermost
        ];
      };
      services.postgresql = {
        enable = true;
        authentication = pkgs.lib.mkForce ''
          local  all all trust
          local  all all trust
          host  all all 127.0.0.1/32 trust
          host  all all ::1/128      trust
        '';
      };
      services.mattermost = {
        enable = true;
        siteUrl = "https://mattermost.gargantua1.0x80.ninja"; #TODO this should be more generic
      };
    };
  };

}
