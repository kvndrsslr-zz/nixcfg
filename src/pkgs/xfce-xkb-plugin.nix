{ lib, xfce }:

lib.overrideDerivation (xfce.xfce4_xkb_plugin) (o:{
  name = o.name + "-patched";
});
