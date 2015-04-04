{ config, pkgs, ... } :

{
  environment.etc."template_XResources".source = ../cfg/Xresources;
  environment.etc."template_vimrc".source = ../cfg/vimrc;
  environment.etc."template_ssh_config".source = ../cfg/ssh_config;
  environment.etc."template_tigrc".source = ../cfg/tigrc;
  environment.etc."template_gdbinit".source = ../cfg/gdbinit;

  nixpkgs.config = {
    packageOverrides = pkgs : {
      cfginit = pkgs.callPackage ../pkgs/cfginit.nix { template = "/etc/template"; };
    };
  };

  environment.systemPackages = with pkgs ; [
    cfginit
  ];

}
