{ stdenv, diffutils, template, writeText }:
let

  mkscript = path : text : ''
    mkdir -pv `dirname ${path}`
    cat > ${path} <<"EOF"
    #!/bin/sh
    ME=`basename ${path}`
    ${text}
    EOF
    sed -i "s@%out@$out@g" ${path}
    chmod +x ${path}
  '';

  s = mkscript "$out/bin/cfginit" ''

    DRYRUN=n
    DEBUG=n
    while test -n "$1" ; do
      case $1 in
        --dry-run) DRYRUN=y;;
        --debug) DEBUG=y;;
        -h|--help|*) echo "Usage: cfginit [--dry-run] [--debug]" >&2; exit 1;;
      esac
      shift
    done

    test "$DEBUG" = "y" && set -x
    test "$DRYRUN" = "y" && DR="echo"

    cpy() {
      local src=$1
      local dst=$2

      local dir=`dirname $dst`
      if ! test -d "$dir" ; then
        $DR mkdir -pv "$dir"
      fi

      $DR cp --verbose "$src" "$dst"
    }

    check_cpy() {
      local src=$1
      local dst=$2

      if test -f "$dst" ; then
        if ! ${diffutils}/bin/diff -u "$src" "$dst" ; then
          echo "File $dst already exists and differs from the template, overwrite ? [y/n] "
          read ans
          case $ans in
            y|Y|yes)
              cpy "$src" "$dst"
            ;;
            *)
              echo "Skipping $dst"
            ;;
          esac
        else
          echo "File $dst matches default, skipping"
        fi
      else
        cpy "$src" "$dst"
      fi
    }

    for f in ${template}* ; do
      case $f in
        *ssh_config)
          check_cpy "$f" "$HOME/.ssh/config"
          ;;
        *)
          df=`echo $f | sed 's@${template}_\(.*\)@\1@'`
          check_cpy "$f" "$HOME/.$df"
          ;;
      esac
    done
  '';

in
stdenv.mkDerivation {
  name = "cfginit";

  builder = writeText "builder.sh" ''
    . $stdenv/setup
    ${s}
  '';

  meta = {
    description = "Initializes user dotfiles from the pre-defined templates";
    maintainers = with stdenv.lib.maintainers; [ smironov ];
    platforms = with stdenv.lib.platforms; linux;
  };
}

