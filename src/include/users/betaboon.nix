{ config, pkgs, ... } :
{

  users.extraUsers.betaboon = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = ["wheel" "audio"];
    home = "/home/betaboon";
    useDefaultShell = true;
  };

}

