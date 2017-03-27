#!/bin/sh
for c in $(nixos-container list); do echo "re-starting: $c" && nixos-container stop $c && nixos-container start $c; done
