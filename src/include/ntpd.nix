{ config, pkgs, ... } :

with pkgs;
{

  services.ntp = {
    enable = true;
    servers = [ "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];
    extraFlags=["-4"];
  };

}


