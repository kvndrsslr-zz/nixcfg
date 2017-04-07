{ config, lib, pkgs, ... }:
let

  hostName = "mattermost";
  domainName = "gargantua1.0x80.ninja";
  fqdn = "${hostName}.${domainName}";

  hostAddress = "192.168.101.100";
  localAddress = "192.168.101.101";

  databaseHost = "192.168.102.101";
  databasePort = "5432";
  databaseName = "mattermost";
  databaseUser = "mmuser";
  databasePassword = import ./mattermost-dbpassword.nix;

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
            8065 # mattermost
          ];
        };
      };
      services.mattermost = {
        enable = true;
        siteUrl = "https://${fqdn}"; #TODO this should be more generic
        localDatabaseName = "${databaseName}";
        localDatabaseUser = "${databaseUser}";
        localDatabasePassword = "${databasePassword}";
        extraConfig = {
          RateLimitSettings.MemoryStoreSize = 1000;
          SqlSettings = {
            DataSource = "postgres://${databaseUser}:${databasePassword}@${databaseHost}:${databasePort}/${databaseName}?sslmode=disable&connect_timeout=10";
            MaxOpenConns = 200;
          };
          ServiceSettings = {
            EnableTesting = true;
            EnableLinkPreviews = true;
          };
        };
        
        localDatabaseCreate = false; #FIXME this should not be required.
        # Currently I am having problems using the automatic sql setup.
        # It runs into all sorts of problems.
      };
      environment.systemPackages = with pkgs; [
	#TODO this set of tools should go into a user-profile-kinda-thing
        lsof
        strace
        python
        htop
        screen
        vim
      ];
    };
  };

  # Nginx-reverse-proxy configuration
  services.nginx.virtualHosts."${fqdn}" = {
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


}
