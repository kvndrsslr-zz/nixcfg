#!/bin/sh
for c in $(nixos-container list); do nixos-container start $c && echo $c; done
