{ config, lib, pkgs, ... }:
let

  hostname = "znc";

in{

  containers."${hostname}" = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.104.100";
    localAddress = "192.168.104.101";

    config = { config, pkgs, ...}: {
      networking.enableIPv6 = false;
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [
          5000 # znc
        ];
      };
      services.znc = {
        enable = true;
        confOptions = {
          port = 5000;
#         useIPv6 = false; # not supported ...
          useSSL = true;
          modules = [ "webadmin" "adminlog" "log" ];
          passBlock = ''
            <Pass password>
              Method = sha256
              Hash = bb3a34b311ccfa3d9326dd8c07d758eea6687421d2fb33ab20c54c94f592796b
              Salt = mwDZ?93ZC:e)B4?UQ:vx
            </Pass>
          '';
        };
      };
    };
  };

}
