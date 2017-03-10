{ config, pkgs, ... } :
{

  users.extraUsers = {
    betaboon = {
      uid = 1000;
      group = "users";
      extraGroups = ["wheel" "audio"];
      home = "/home/betaboon";
      useDefaultShell = true;
    };
  };

}

