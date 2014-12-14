{ stdenv, bash, writeText, coreutils, gnugrep, gnused, findutils, systemd,
udisks2, yad, imagemagick }:
let 
  mkscript = path : text : ''
    mkdir -pv `dirname ${path}`
    cat > ${path} <<"EOF"
    #!${bash}/bin/bash
    ME=`basename ${path}`
    ${text}
    EOF
    sed -i "s@%out@$out@g" ${path}
    chmod +x ${path}
  '';


  ff = mkscript "$out/bin/photofetcher" ''
    YAD=${yad}/bin/yad
    UDISK=${udisks2}/bin/udisksctl
    UDEVADM=${systemd}/bin/udevadm
    SED=${gnused}/bin/sed
    FIND=${findutils}/bin/find

    err() { $YAD --image  "dialog-error"  --title  "Alert" --button=gtk-ok:0 --text  "$@" ; }
    dbg() { echo $@ >&2; }
    die() { err "$@" ; exit 1; }
    diec() { echo "$@" >&2; exit 1; }


    T=""
    while test -n "$1" ; do
      case $1 in
        -h|--help) diec "Usage: `basename $0` TGTDIR" ;;
        *) T="$1";;
      esac
      shift
    done

    test -n "$T" || diec "Target directory is not specified. See --help."
    test -d "$T" || diec "Argument is not a directory ($T)"


    D=$($FIND /dev/disk/by-id -maxdepth 1 -name 'usb*')

    mountpoint() {
      $UDISK info -b $1 | $SED -n 's/.*MountPoints: *\([^ ]\+\)/\1/p'
    }

    suremount() {
      local MP=`mountpoint $1`
      if ! test -d "$MP" ; then
        if ! $UDISK mount -b $1 --no-user-interaction >&2 ; then
          dbg "Mount failed"
          echo ""
          return 1
        fi
      else
        dbg "Already mounted ($MP)"
        echo $MP
        return 0
      fi

      MP=`mountpoint $1`
      echo $MP
      return 0
    }

    NDEV=0
    for d in $D ; do
      MP=`suremount $d`
      if ! test -n "$MP" ; then
        continue
      fi
      if ! test -d "$MP" ; then
        continue
      fi

      dbg "MP is $MP"
      NDEV=`expr $NDEV '+' 1`

      FILES=``
      N=`$FIND "$MP/DCIM" -iname '*\.jpg' | wc -l`
      $FIND "$MP/DCIM" -iname '*\.jpg' | while read f ; do
        echo $f
        i=`expr $i + 1`

        cp "$f" "$T"

        echo `expr $i '*' 100 / $N`

      done | $YAD --auto-close --progress --text "Идёт копирование"
    done

    if test "$NDEV" = "0" ; then
      die "Не найдено ни одного USB устройсва"
    fi
  '';

  mv = mkscript "$out/bin/photomove" ''
    YAD=${yad}/bin/yad
    UDISK=${udisks2}/bin/udisksctl
    UDEVADM=${systemd}/bin/udevadm
    SED=${gnused}/bin/sed
    FIND=${findutils}/bin/find

    err() { $YAD --image  "dialog-error"  --title  "Alert" --button=gtk-ok:0 --text  "$@" ; }
    dbg() { echo $@ >&2; }
    die() { err "$@" ; exit 1; }
    diec() { echo "$@" >&2; exit 1; }

    if test "$1" = "" ; then
      die "Необходимо сначала выделить файлы, которые требуется скопировать"
    fi

    D=$($YAD \
      --title="В какую папку переместить эти файлы?" \
      --text="В какую папку переместить эти файлы?" \
      --text-align=center \
      --file-selection --geometry=800x500 --directory)

    if ! test "$?" = "0" ; then
      exit 1;
    fi 

    if ! test -d "$D" ; then
      die "Нельзя переместить файлы в эту директорию ($D)"
    fi

    while test -n "$1" ; do
      mv -t "$D" $1
      shift
    done

  '';

  binfind = "${findutils}/bin/find";
  binyad = "${yad}/bin/yad";
  binconvert = "${imagemagick}/bin/convert";

  rsz = mkscript "$out/bin/photoresize" ''
    err() { ${binyad} --image  "dialog-error"  --title  "Alert" --button=gtk-ok:0 --text  "$@" ; }
    dbg() { echo $@ >&2; }
    die() { err "$@" ; exit 1; }
    diec() { echo "$@" >&2; exit 1; }

    findimg() {
      ${binfind} . -maxdepth 1 -iname '*\.jpg'
    }

    i=0
    N=`findimg | wc -l`
    if test "$N" = "0" ; then
      die "Ни одной фотографии (файл.JPG) не найдено в этой папке"
    fi

    findimg | while read f ; do
      ${binconvert} -resize 800x600 "$f" "$f.small" && mv "$f.small" "$f"
      i=`expr $i + 1`
      echo `expr $i '*' 100 / $N`
    done | ${binyad} --auto-close --progress --text "Уменьшение до 800x600"
  '';

in
stdenv.mkDerivation {
  name = "photofetcher-1.0";

  builder = writeText "builder.sh" ''
    . $stdenv/setup
    ${ff}
    ${mv}
    ${rsz}
  '';

  meta = {
    description = "Photofetcher is a tool which fetches photos from a remote media";
    maintainers = with stdenv.lib.maintainers; [ smironov ];
    platforms = with stdenv.lib.platforms; linux;
  };
}


