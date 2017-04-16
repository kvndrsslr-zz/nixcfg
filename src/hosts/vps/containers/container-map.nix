# WIP
# !!! this file is not functional !!!
#
# current purpose:
# - central documentation of container-networking settings
#
# ultimate purpose:
# - central configuration of container-networking settings
# - should be used for container-network-config
# - should be used for nat
# - should be used for nginx-reverse-proxy
#
# todos:
# - how do you actually use 'container_map' somewhere else?
# - which settings should be centralized ?

{ config, lib, pkgs, ... }: # TODO config, ... should be enough ? oO

let

  domainName = "gargantua1.0x80.ninja";
  container_map = [
    { hostName = "test";          subnet = 100; reverseProxy =   80; acme = true; };
    { hostName = "mattermost";    subnet = 101; reverseProxy = 8065; acme = true; };
    { hostName = "mmdb";          subnet = 102; };
#   { hostName = "taiga";         subnet = 103; reverseProxy =   80; acme = true; };
  ];

in {

}
