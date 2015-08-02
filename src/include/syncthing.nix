{ config, pkgs, ... } :
{
  services.syncthing.enable = true;
  services.syncthing.dataDir = "/home/syncthing";

  users.extraUsers = {

    syncthing = {
      group = "users";
      home = "/home/syncthing";
      useDefaultShell = true;
    };

  };
}
