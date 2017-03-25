{ config, lib, pkgs, ... }:
let

  hostname = "znc";

in{

  containers."${hostname}" = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.102.100";
    localAddress = "192.168.102.101";

    config = { config, pkgs, ...}: {
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [
          5000 # znc
        ];
      };
      imports = [ ../services/znc.nix ];
    };
  };

}