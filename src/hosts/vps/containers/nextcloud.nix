{ config, lib, pkgs, ... }:
let

  hostname = "nextcloud";

  nextcloudUser = "www-data";
  nextcloudGroup = "www-data";
  nextcloudPath = "/var/lib/nextcloud";
in {

  containers."${hostname}" = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.102.100";
    localAddress = "192.168.102.101";

#    bindMounts = {
#      "/webroot" = {
#        hostPath="/var/www/static-page";
#        isReadOnly = true;               
#        };
#    };

    config = { config, pkgs, ...}: {
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 80 ];
      };
      environment.systemPackages = with pkgs; [ php vim ];


#      users.mutableUsers = false;
      users.users."${nextcloudUser}" = {
        isNormalUser = true;
        group = "${nextcloudGroup}";
        home = "/var/www";
        useDefaultShell = true;
        createHome = true;
      };
      users.groups."${nextcloudGroup}".name = "${nextcloudGroup}";

      services.postgresql = {
        enable = true;
        authentication = ''
          local all       all ident
        '';
      };

      services.nginx = {
        enable = true;
        user = "${nextcloudUser}";
        group = "${nextcloudGroup}";
      };

      services.nginx.virtualHosts."${hostname}" = {
        enableSSL = false;
        extraConfig = ''
          # Path to the root of your installation
          root ${pkgs.nextcloud};
          # set max upload size
          client_max_body_size 10G;
          fastcgi_buffers 64 4K;

          # Disable gzip to avoid the removal of the ETag header
          gzip off;

          # Uncomment if your server is build with the ngx_pagespeed module
          # This module is currently not supported.
          #pagespeed off;

          index index.php;
          error_page 403 /core/templates/403.php;
          error_page 404 /core/templates/404.php;
          add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload;";
          add_header X-Content-Type-Options nosniff;
          add_header X-Frame-Options "SAMEORIGIN";
          add_header X-XSS-Protection "1; mode=block";
          add_header X-Robots-Tag none;
          add_header X-Download-Options noopen;
          add_header X-Permitted-Cross-Domain-Policies none;

          location = /robots.txt {
            allow all;
            log_not_found off;
            access_log off;
          }

          location ~ ^/(?:\.htaccess|data|config|db_structure\.xml|README) {
            deny all;
          }

          location = /.well-known/carddav {
            return 301 $scheme://$host/remote.php/dav;
          }

          location = /.well-known/caldav {
            return 301 $scheme://$host/remote.php/dav;
          }

          location / {
            rewrite ^(/core/doc/[^\/]+/)$ $1/index.html;
            try_files $uri $uri/ /index.php;
          }

          location ~ \.php(?:$|/) {
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            include ${pkgs.nginx}/conf/fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_param PATH_INFO $fastcgi_path_info;
            fastcgi_param HTTPS off;
            fastcgi_pass unix:/run/phpfpm/nextcloud.sock;
            fastcgi_intercept_errors on;
          }

          # Adding the cache control header for js and css files
          # Make sure it is BELOW the location ~ \.php(?:$|/) { block
          location ~* \.(?:css|js)$ {
            add_header Cache-Control "public, max-age=7200";
            # Add headers to serve security related headers
            add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload;";
            add_header X-Content-Type-Options nosniff;
            add_header X-Frame-Options "SAMEORIGIN";
            add_header X-XSS-Protection "1; mode=block";
            add_header X-Robots-Tag none;
            # Optional: Don't log access to assets
            access_log off;
          }

          # Optional: Don't log access to other assets
          location ~* \.(?:jpg|jpeg|gif|bmp|ico|png|swf)$ {
            access_log off;
          }

          location ^~ /apps {
            alias ${nextcloudPath}/apps;
          }
        '';
      };

      systemd.services.nextcloud-startup = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = pkgs.writeScript "nextcloud-startup" ''
            #! ${pkgs.bash}/bin/bash

            ncpath='${nextcloudPath}'
            htuser='${nextcloudUser}'
            htgroup='${nextcloudGroup}'
            rootuser='root'
            if (! test -e "''${ncpath}"); then
              printf "Setting up Nextcloud in ''${ncpath}\n"
              ${pkgs.rsync}/bin/rsync -a --checksum "${pkgs.nextcloud}/" "''${ncpath}/"

              printf "Creating possible missing Directories\n"
              mkdir -p $ncpath/data
              mkdir -p $ncpath/updater

              printf "chmod Files and Directories\n"
              find ''${ncpath}/ -type f -print0 | xargs -0 chmod 0640
              find ''${ncpath}/ -type d -print0 | xargs -0 chmod 0750

              printf "chown Directories (''${htuser}:''${htgroup}\n"
              chown -R ''${rootuser}:''${htgroup} ''${ncpath}/
              chown -R ''${htuser}:''${htgroup} ''${ncpath}/apps/
              chown -R ''${htuser}:''${htgroup} ''${ncpath}/config/
              chown -R ''${htuser}:''${htgroup} ''${ncpath}/data/
              chown -R ''${htuser}:''${htgroup} ''${ncpath}/themes/
              chown -R ''${htuser}:''${htgroup} ''${ncpath}/updater/

              chmod +x ''${ncpath}/occ

              printf "chmod/chown .htaccess\n"
              if [ -f ''${ncpath}/.htaccess ]
              then
                chmod 0644 ''${ncpath}/.htaccess
                chown ''${rootuser}:''${htgroup} ''${ncpath}/.htaccess
              fi
              if [ -f ''${ncpath}/data/.htaccess ]
              then
                chmod 0644 ''${ncpath}/data/.htaccess
                chown ''${rootuser}:''${htgroup} ''${ncpath}/data/.htaccess
              fi
            fi
          '';
        };
        enable = true;
      };

      systemd.services.nextcloud-cron = {
        after = [ "network.target" ];
        script = ''
          ${pkgs.php}/bin/php ${pkgs.nextcloud}/cron.php
          ${pkgs.nextcloud-news-updater}/bin/nextcloud-news-updater -i 15 --mode singlerun ${pkgs.nextcloud}
        '';
        environment = { NEXTCLOUD_CONFIG_DIR = "${nextcloudPath}/config"; };
        serviceConfig.User = "${nextcloudUser}";
      };

      systemd.timers.nextcloud-cron = {
        enable = true;
        wantedBy = [ "timers.target" ];
        partOf = [ "nextcloud-cron.service" ];
        timerConfig = {
          OnCalendar = "*-*-* *:00,15,30,45:00";
          Persistent = true;
        };
      };

      services.phpfpm.poolConfigs.nextcloud = ''
        user = ${nextcloudUser}
        group = ${nextcloudGroup}
        listen = /run/phpfpm/nextcloud.sock
        listen.owner = ${nextcloudUser}
        listen.group = ${nextcloudGroup}
        catch_workers_output = yes
        pm = dynamic
        pm.max_children = 5
        pm.start_servers = 2
        pm.min_spare_servers = 1
        pm.max_spare_servers = 3
        pm.max_requests = 500
        env[NEXTCLOUD_CONFIG_DIR] = "${nextcloudPath}/config"
        php_flag[display_errors] = off
        php_admin_value[error_log] = /run/phpfpm/php-fpm.log
        php_admin_flag[log_errors] = on
        php_value[date.timezone] = "UTC"
        php_value[upload_max_filesize] = 10G
        php_value[cgi.fix_pathinfo] = 1
      '';

      };
    };

}
