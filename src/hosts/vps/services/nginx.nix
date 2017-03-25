{ config, pkgs, ... }:
{

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "0x80.ninja" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "gargantua1.0x80.ninja" ];
        root = /var/www/static-page;
      };
      "test.gargantua1.0x80.ninja" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://192.168.100.101";
        };
      };
      "mattermost.gargantua1.0x80.ninja" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://192.168.101.101:8065";
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
          proxyPass = "http://192.168.101.101:8065";
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
    };
  };

}
