#!/bin/sh
for c in $(nixos-container list); do echo "starting: $c" && nixos-container start $c; done
