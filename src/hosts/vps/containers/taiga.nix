{ config, lib, pkgs, ... }:
let

  hostname = "taiga";

in{

  containers."${hostname}" = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.103.100";
    localAddress = "192.168.103.101";

    config = { config, pkgs, ...}: {
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 80 ];
      };
      services.nginx = {
        enable = true;
        virtualHosts."${hostname}" = {
          enableSSL = false;
          clientMaxBodySize = "50m";
          extraConfig = ''
            large_client_header_buffers 4 32k;
            charset utf-8;
          '';
          locations = {
            "/" = {
              root = /home/taiga/taiga-front-dist/dist/;
              tryFiles = "$uri $uri/ /index.html";
            };
            "/api" = {
              proxyPass = "http://127.0.0.1:8001/api";
              extraConfig = ''
                proxy_set_header Host $http_host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Scheme $scheme;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_redirect off;
              '';
            };
            "/admin" = {
              proxyPass = "http://127.0.0.1:8001$request_uri";
              extraConfig = ''
                proxy_set_header Host $http_host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Scheme $scheme;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_redirect off;
              '';
            };
            "/static" = {
              extraConfig = "alias /home/taiga/taiga-back/static";
            };
            "/media" = {
              extraConfig = "alias /home/taiga/taiga-back/media";
            };
          };
        };
      };
    };
  };

}
