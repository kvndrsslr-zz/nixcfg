{ pkgs, extra ? null} :

with pkgs ;
let 

  git = gitAndTools.gitFull;

  gitbin = "${git}/bin/git";

in pkgs.writeText "myprofile.sh" ''
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
  gitka() 		{ LANG=C ${git}/bin/gitk --all "$@" & }
  mcd() 		{ mkdir "$1" && cd "$1" ; }
  vimless() { ${vimHugeX}/bin/vim -R "$@" - ; }
  pfind() 	{ ${findutils}/bin/find -iname "*$1*" ; }
  d() 	    { if test -z "$1" ; then
                load-env-dev
              else
                load-env-dev-$1
              fi
            }
  manconf() { ${man}/bin/man configuration.nix ; }
  gf()      { ${git}/bin/git fetch github || ${git}/bin/git fetch origin ; }
  beep()    { aplay ~/proj/dotfiles/beep.wav ; }

  alias ga='${gitbin} add'
  alias gai='${gitbin} add -i'
  alias gb='${gitbin} branch'
  alias gc='${gitbin} commit'
  alias gco='${gitbin} checkout'
  alias gcp='${gitbin} cherry-pick'
  alias gd='${gitbin} diff'
  alias gg='${gitbin} grep'
  alias gl='${gitbin} log'
  alias gm='${gitbin} merge'
  alias gp='${gitbin} push'
  alias gpff='${gitbin} pull --ff'
  alias gr='${gitbin} reset'
  alias grh='${gitbin} reset --hard'
  alias grm='${gitbin} remote'
  alias grma='${gitbin} remote add'
  alias gs='${gitbin} status'
  alias gsta='${gitbin} stash pop'
  alias gstl='${gitbin} stash list'
  alias gsts='${gitbin} stash save'

  vim()     {
    case "$1" in
      "") ${vimHugeX}/bin/vim . ;;
      *) ${vimHugeX}/bin/vim "$@" ;;
    esac
  }

  # Set window name
  wn() { ${wmctrl}/bin/wmctrl -r :ACTIVE: -T "$@";  }

  # Set screen window name
  sn() {
    PID=$(echo $STY | awk -F"." '{ print $1}')
    if test -n "$PID" ; then
      ${screen}/bin/screen -D -r "$PID" -X title "$@"
    else
      echo "Failed to get PID. Do you have GNU/Screen running?" >&2
    fi
  }

  if env | grep -q SSH_CONNECTION= ; then
    if env | grep -q DISPLAY= ; then
      echo DISPLAY is $DISPLAY >/dev/null
      echo "export DISPLAY=$DISPLAY" > $HOME/.display
    else
      echo No DISPLAY was set >/dev/null
    fi
  fi

  make() {
    if test -f "Makefile.dev" ; then
      ${gnumake}/bin/make -f Makefile.dev "$@"
    else
      ${gnumake}/bin/make "$@"
    fi
  }

  ${if extra != null then extra else ""}
''

