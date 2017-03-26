{ config, lib, pkgs, ... }:
let

  hostName = "mattermost";
  domainName = "gargantua1.0x80.ninja";
  fqdn = "${hostName}.${domainName}";

  hostAddress = "192.168.101.100";
  localAddress = "192.168.101.101";

in{
  services.nginx.virtualHosts."${hostName}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://${localAddress}:8065";
      extraConfig = ''
        client_max_body_size 50M;
        proxy_set_header Connection "";
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Frame-Options SAMEORIGIN;
        proxy_buffers 256 16k;
        proxy_buffer_size 16k;
        proxy_read_timeout 600s;
        # proxy_cache mattermost_cache;
        # proxy_cache_revalidate on;
        # proxy_cache_min_uses 2;
        # proxy_cache_use_stale timeout;
        # proxy_cache_lock on;
      '';
    };
    locations."/api/v3/users/websocket" = {
      proxyPass = "http://${localAddress}:8065";
      extraConfig = ''
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        client_max_body_size 50M;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Frame-Options SAMEORIGIN;
        proxy_buffers 256 16k;
        proxy_buffer_size 16k;
        proxy_read_timeout 600s;
      '';
    };
  };

  containers."${fqdn}" = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "${hostAddress}";
    localAddress = ${localAddress}";

    config = { config, pkgs, ...}: {
      networking.enableIPv6 = false;
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [
          8065 # mattermost
        ];
      };
      services.postgresql = {
        enable = true;
        authentication = pkgs.lib.mkForce ''
          host  all all 127.0.0.1/32 trust
          host  all all ::1/128      trust
        '';
      };
      services.mattermost = {
        enable = true;
        siteUrl = "https://${fqdn}"; #TODO this should be more generic
      };
    };
  };

}
