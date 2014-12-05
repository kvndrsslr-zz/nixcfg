{ config, pkgs, ... } :
{
  environment.systemPackages = with pkgs ; [
    (pkgs.callPackage ../pkgs/firefoxLocaleWrapper.nix {language = "ru";})
  ];

  nixpkgs.config = {
    firefox = {
      jre = true;
      enableAdobeFlash = true;
    };
  };
}
