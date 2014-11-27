{ config, pkgs, ... } :

{

  programs = {

    screen = {

      screenrc = ''
        vbell off
        msgwait 1
        defutf8 on
        startup_message off
        defscrollback 5000
        altscreen on
        autodetach on
        hardstatus alwayslastline "%{= Kw} %H : %{= Kw}%-w%{= wk}%n %t%{= Kw}%+w"

        multiuser on
        acldel guest
        chacl guest -r-w-x "#?"

        term screen-256color

        defbce "on"

        deflogin on
        shell -$SHELL

        bind q quit
        bind u copy
        bind s
        bind 0 number 0
        bind 1 number 1
        bind 2 number 2
        bind 3 number 3
        bind 4 number 4
        bind 5 number 5
        bind 6 number 6
        bind 7 number 7
        bind k kill

        bindkey ^[1 prev
        bindkey ^[2 next
        bindkey ^[q prev
        bindkey ^[й prev
        bindkey ^[w next
        bindkey ^[ц next
        bindkey ^[` other
      '';

    };
  };
}
