{ config, pkgs, ... } :

{
  environment.etc."template_XResources".source = ../cfg/Xresources;
  environment.etc."template_vimrc".source = ../cfg/vimrc;
  environment.etc."template_ssh_config".source = ../cfg/ssh_config;
}
