{ config, pkgs, ... }:
{

  security.acme = {
    directory = "/var/www/challenges";
    certs = {
      "0x80.ninja" = {
        webroot = config.security.acme.directory;
        email = "admin@0x80.ninja";
        user = "nginx";
        group = "nginx";
        postRun = "systemctl restart nginx.service";
      };
      "gargantua1.0x80.ninja" = {
        webroot = config.security.acme.directory;
        email = "admin@0x80.ninja";
        user = "nginx";
        group = "nginx";
        postRun = "systemctl restart nginx.service";
        extraDomains = {
          "test.gargantua1.0x80.ninja" = null;
        };
      };
    };
  };

}
