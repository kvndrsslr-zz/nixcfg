{ config, pkgs, ... } :
{
  services.syncthing.enable = true;

  users.extraUsers = {

    syncthing = {
      group = "users";
      home = "/home/syncthing";
      useDefaultShell = true;
    };

  };
}
