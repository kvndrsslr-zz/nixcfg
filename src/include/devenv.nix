{ config, pkgs, ... } :

{
  nixpkgs.config = {

    packageOverrides = pkgs : {

      devlibs_x11 = with pkgs ; [
        freetype
        fontconfig
        xlibs.xproto
        xlibs.libX11
        xlibs.libXt
        xlibs.libXft
        xlibs.libXext
        xlibs.libSM
        xlibs.libICE
        xlibs.xextproto
        xlibs.libXrender
        xlibs.renderproto
        xlibs.libxkbfile
        xlibs.kbproto
        xlibs.libXrandr
        xlibs.randrproto
      ];

      devlibs_cross = with pkgs; [
        i386_toolchain.gcc
        i386_toolchain.binutils
        i386_toolchain.gdb
        arm_toolchain_bare.gcc
        arm_toolchain_bare.binutils
        arm_toolchain_bare.gdb
        avr_toolchain.gcc
        avr_toolchain.binutils
        avr_toolchain.gdb
      ];

      devenv = { name ? "dev", extraPkgs ? [], enableCross ? false} : let

        common = with pkgs; [
          autoconf
          automake
          gettext
          flex
          bison
          intltool
          libtool
          pkgconfig
          perl
          curl
          sqlite
          postgresql92
          cmake
          python
          ncurses
          curl
          zlib
          patchelf
          m4
          perlPackages.LWP
          gtk_doc
          glib
          gdb
          gmp
          mpfr
          utf8proc
          gcc
        ];

        myprofile = import ./myprofile.nix {
          inherit pkgs;
          extra = ''
            PROMPT_COLOR="0;35m"
            PS1="\n\[\033[$PROMPT_COLOR\][\u@\h-${name} \w ]\\$\[\033[0m\] "
            export LANG=C
          '';
        };

      in pkgs.myEnvFun {

          inherit name;

          buildInputs = with pkgs.stdenv.lib; common ++ extraPkgs;

          shell = "${pkgs.bashInteractive}/bin/bash --noprofile --rcfile ${myprofile}";

      };
    };
  };

}
