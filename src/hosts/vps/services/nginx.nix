{ config, pkgs, ... }:
{

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "0x80.ninja" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "gargantua1.0x80.ninja" ];
        root = /var/www/static-page;
      };
    };
  };

}
