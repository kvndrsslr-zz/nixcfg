{ config, pkgs, ...}:
{
  
  services.znc = {
      enable = true;
      confOptions = {
        port = 5000;
#        useIPv6 = false; # not supported ...
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

}
