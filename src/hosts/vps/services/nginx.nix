{ config, pkgs, ... }:
{

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
      server {
        server_name test.gargantua1.0x80.ninja;
        listen 443 ssl;
        ssl_certificate     ${config.security.acme.directory}/gargantua1.0x80.ninja/fullchain.pem;
        ssl_certificate_key ${config.security.acme.directory}/gargantua1.0x80.ninja/key.pem;
        location / {
          proxy_pass http://192.168.100.101:80;
        }
      }
    '';
  };

}
