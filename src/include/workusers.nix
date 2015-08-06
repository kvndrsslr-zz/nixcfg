{ config, pkgs, ... } :
let
  lib = pkgs.lib;

  mykey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC//4n9w+NopP8L9Mndo1RYWwuCBbwHb8TflZW4FRwEno7gUyvSfAYCruLdkm142E3ZuOdZdrXl+Qeu250wxSp3cq/jm8N787wgWAA99jtCdFkWvOg9n4WRZEabS2D8UVbECqPkRoYSwqGEA3hrXc6NvseJVCJW5i6eFQNkeltFSaOtaUhtJ2oxU3c1yCO8xqpUCT/8j0Ktjmubri7/pC0NMoJu8GWhkYG1QAl5DxPhX6p1eJ1W9TmD+SzdqyBwE967wPhNBLOqttJwlNqSkxNfRiZzxFCaB61XLxW1WmcWizr23oU4Ha99eCTR/WqnhZDepoL/YgZalkj3DPBWi4wt grwlf@ww";

  colleges = [
    { name = "ildar";
      key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrnWzmNddFt5qMYYSh3FVKGwYUybRiagZ9AAxxEfeNGYGdpOipWsM5dQ241fUWNA9w2p+Iy2lqCNZ+4raYCwawsQ60x3uO02xzFAqFUGe0vgxta3vtQIX1ls9jFCIyt8RgVZxBTGKnsISEMTuYRKDWkeRQ/RixoMN5g1F0WdJ61SKOB1n0WCZvATYEy3IV8z0nTkYOXVcLEAWh+SmvXZAMXwugb0SLENZmalFxlXQrGjkyi6IIM7baXTkesOklBWZLo//R9M1BLAARrSpphes/b8RJBaKEiFyyGIQkfekqAPUnuM9D3x8qHsGXwEqsu3mMBYas555UptlM8Afm5Wkp ildar@ildar-pc";
    }
    { name = "potemkin";
      key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUbdOL745zVd5g8hIp5o2bfSiy81b7y9zQE52a6fDoU233QUK/xT8aCRBW9VPWHcjVxe+SVWkX6LeKXMHPx01JTZdxfRKJt4q4gsev8tBbNGz+VKlLnf0Q8oe32oGtEOIg0i1+sxgT0owo5BPhicvynrRy2BSvAXAnd6AN5Ghj0ez3suWJY1j3vQ6bXWswkYEbr0r4kegqxAW6EwENBnTFlVuscxXDsc4Cjq+nbf/vOc7tj/RxYSrzjJWrySAu/BEkjj9pPMLXQISGV6oqFwYVkL3PHoa4wk96sEoiVQGUoETQjtjGMDc3K0ZvHM6wIQcl6T912Cq7BXqqy7Ue0ehP developer@developer-System-Product-Name";
    }
    { name =  "dvyal";
      key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUYhWpWRBAXgtGz/ihjLI1PFOVBw5ua2eTLpR39hnphts7FMI/7CEJEAdoXCx+ztIVuVRnvEzTraFfGbkVHSqC8lG+7AIMBdzIphRHQo88BQNgvCk7Ju7XXyoSKiUEL17EJaLKyVk5G2kP0vSPOCMkReLuMX5vtjAF+DcVa7ZngyvnvliFVPxgE3MxXI76LW+jRMj1wkeM8KSqZa0n/M7+nkCr1U7zjBrUmJzsPq321h/Mfd4SyjSROU9A4TX/r+bw/DffjNWcocZcy8XXzvw9Y7O/z5NxYEkns3nq3cZxyj4DiPJVr913b2Sbf6nHMVBw46EAOytwNqUMreuBJUU5 dvyal@dvyal-desktop";
    }
    { name =  "vshebordaev";
      key = "";
    }
    { name = "poohber";
      key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7OY7y+4qyJH+V9+3jsBEzuKnPXSwa1pGtT/lTkhqgT17D22RFzu1HwEIxw2MgBjpizVGgW/7GWyg8CARNGDUdjZW40P0b8g7S3psU7Keynxu2Dsnx46Ym0ITWtb6sH3/iuY8UvtoOIk+B67NOgSqfrBE+v0azHBB5wHwIuse2Ubq6r51monCvTwKvEB2uiUHwrm89GCn7hTjFXoCGy3YzkUGUoPU3BG578o7UX+X6jpHDDOOgtDoqSzLqhzDEJ4TPeqrEEJ9RpbXTK4YifAep4y29ANgCowaB1HB0wp9tfymGSkA6DFVX2ZDhOQC+qpxvUvEXPhIwhYXzbf3naqeF anechay@ecotelecom.ru";
    }];

  for_all_colleges = f : lib.concatMapStrings f colleges;
in
{
  users.extraUsers = builtins.listToAttrs (lib.imap (i : n : {
      name = n.name;
      value = {
        uid = 2000 + i;
        group = "users";
        extraGroups = [];
        home = "/home/${n.name}";
        useDefaultShell = true;
      };
    }) ([ { name = "developer" ; } ] ++ colleges));

  environment.etc."mkcolleges".source = pkgs.writeScript "mkcolleges" (
    ''
      mkdir -pv /home/developer/.ssh
      chown developer:users /home/developer
      A=/home/developer/.ssh/authorized_keys
      echo '${mykey}' > $A
      chown developer:users $A

    '' + for_all_colleges ( c : ''

      echo
      echo "Creating ${c.name}"
      mkdir /home/${c.name}
      chown ${c.name}:users /home/${c.name}
      chmod 755 /home/${c.name}

      mkdir /home/${c.name}/.ssh
      chown ${c.name}:users /home/${c.name}/.ssh
      chmod 755 /home/${c.name}/.ssh

      (
      echo ${c.key}
      echo '${mykey}'
      ) > /home/${c.name}/.ssh/authorized_keys

      echo ${c.key} >> $A

      chown ${c.name}:users /home/${c.name}/.ssh/authorized_keys
    ''));

}

