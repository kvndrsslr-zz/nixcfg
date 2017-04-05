{ config, lib, pkgs, ... }:
let

  hostName = "mmdb";
  domainName = "gargantua1.0x80.ninja";
  fqdn = "${hostName}.${domainName}";

  hostAddress = "192.168.102.100";
  localAddress = "192.168.102.101";

in{
  containers."${hostName}" = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "${hostAddress}";
    localAddress = "${localAddress}";

    config = { config, pkgs, ...}: {
      networking = {
        enableIPv6 = false;

        firewall = {
          enable = true;
          allowPing = true;
          allowedTCPPorts = [
            5432 # postgres
          ];
        };
      };
      services.postgresql = {
        enable = true;
        port = 5432;
        enableTCPIP = true;
        extraConfig = ''
          log_line_prefix = '[%p] [%c] [%m] [%x]: '
          log_statement = 'all'
        '';

        authentication = pkgs.lib.mkForce ''
          local  all all trust
          local  all all trust
          #      database user address         auth-method
          #TODO improve 'password'
          host   all      all  127.0.0.1/32    trust
          host   all      all  ::1/128         trust
          host   all      all  192.168.101.101/32 password
        '';
      };
      environment.systemPackages = with pkgs; [
        lsof
        strace
        tcpdump
        python
        htop
        screen
        vim
      ];
    };
  };

}
