{ config, lib, pkgs, ... }:
{

  containers.test = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.100";
    localAddress = "192.168.100.101";

    config = { config, pkgs, ...}: {
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 80 ];
      };
      services.nginx = {
        enable = true;
        httpConfig = ''
          server {
            listen 80;
            server_name test;
            root /var/www/;
          }
        '';
      };
    };
  };

}
