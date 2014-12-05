{ config, pkgs, ... } :
{
  environment.systemPackages = with pkgs ; [
      photofetcher
  ];

  nixpkgs.config = {
    packageOverrides = pkgs : {

      photofetcher = pkgs.callPackage ../pkgs/photofetcher.nix {};

      xfce = pkgs.xfce // {

        xfce4_xkb_plugin = pkgs.lib.overrideDerivation (pkgs.xfce.xfce4_xkb_plugin) (o:{
          name = o.name + "-patched";
          patches = [ ../pkgs/xfce4-xkb.patch ];
        });

        thunar = pkgs.lib.overrideDerivation pkgs.xfce.thunar (a:{
          name = a.name + "-patched";
          prePatch = ''
            cp -pv ${pkgs.callPackage ../pkgs/thunar_uca.nix {}} plugins/thunar-uca/uca.xml.in
          '';
        });
      };
    };
  };
}
