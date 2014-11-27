{ config, pkgs, ... } :

{
  environment = {

    extraInit = with pkgs ;
      let 
        git = gitAndTools.gitFull;
        gitbin = "${git}/bin/git";
      in ''
      export EDITOR=${vimHugeX}/bin/vim
      export VERSION_CONTROL=numbered
      export SVN_EDITOR=$EDITOR
      export GIT_EDITOR=$EDITOR
      export LANG="ru_RU.UTF-8"
      export OOO_FORCE_DESKTOP=gnome
      export LC_COLLATE=C
      export HISTCONTROL=ignorespace:erasedups
      export PATH="$HOME/.cabal/bin:$PATH"
      export PATH="$HOME/local/bin:$PATH"

      cal()     { `which cal` -m "$@" ; }
      df()      { `which df` -h "$@" ; }
      du()      { `which du` -h "$@" ; }
      man()     { LANG=C ${man}/bin/man "$@" ; }
      feh()     { ${feh}/bin/feh -. "$@" ; }

      q() 		  { exit ; }
      s() 		  { ${screen}/bin/screen ; }
      e() 		  { thunar . 2>/dev/null & }

      log() 		{ ${vimHugeX}/bin/vim /var/log/messages + ; }
      logx() 		{ ${vimHugeX}/bin/vim /var/log/X.0.log + ; }

      cdt() 		{ cd $HOME/tmp ; }
      cdd()     { cd $HOME/dwnl; }
      gitk() 		{ LANG=C ${git}/bin/gitk "$@" & }
      mcd() 		{ mkdir "$1" && cd "$1" ; }
      vimless() { ${vimHugeX}/bin/vim -R "$@" - ; }
      pfind() 	{ ${findutils}/bin/find -iname "*$1*" ; }
      d() 	    { load-env-dev ; }
      manconf() { ${man}/bin/man configuration.nix ; }
      gf()      { ${git}/bin/git fetch github || ${git}/bin/git fetch origin ; }
      beep()    { aplay ~/proj/dotfiles/beep.wav ; }

      alias ga='${gitbin} add'
      alias gb='${gitbin} branch'
      alias gco='${gitbin} commit'
      alias gch='${gitbin} checkout'
      alias gd='${gitbin} diff'
      alias gl='${gitbin} log'
      alias gr='${gitbin} reset'
      alias gm='${gitbin} merge'
      alias grh='${gitbin} reset --hard'
      alias grm='${gitbin} remote'
      alias gs='${gitbin} status'
      alias gsts='${gitbin} stash save'
      alias gsta='${gitbin} stash pop'
      alias gstl='${gitbin} stash list'
      alias gcp='${gitbin} cherry-pick'
      alias gg='${gitbin} grep'

      vim()     {
        case "$1" in
          "") ${vimHugeX}/bin/vim . ;;
          *) ${vimHugeX}/bin/vim $@ ;;
        esac
      }

      # qvim()    { ${qvim}/bin/qvim;
      #             for i in 1 2 ; do ${wmctrl}/bin/wmctrl -r :ACTIVE: -b toggle,maximized_vert,maximized_horz ; done
      #           }
    '';
  };

  programs = {

    bash = {

      promptInit = ''
        PROMPT_COLOR="1;31m"
        let $UID && PROMPT_COLOR="1;32m"
        PS1="\n\[\033[$PROMPT_COLOR\][\u@\h \w ]\\$\[\033[0m\] "
        # if test "$TERM" = "xterm"; then
        #   PS1="\[\033]2;\h:\u: \w\007\ ]$PS1"
        # fi
      '';

      enableCompletion = true;
    };
  };
}

