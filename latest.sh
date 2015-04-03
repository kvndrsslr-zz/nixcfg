#!/bin/sh

me=`basename $0`

rev=`wget -q  --output-document - http://releases.nixos.org/nixos/unstable/ |
  sed -n 's/.*pre.*\.\([a-z0-9]\+\)\/.*/\1/g p' | tail -n 1`

if test -z "$rev" ; then
  echo "$me: Error obtaining channel info from nixos.org" >&2
  exit 1
fi
echo $rev
