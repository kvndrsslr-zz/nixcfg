#!/bin/sh
for c in $(nixos-container list); do nixos-container stop $c && echo $c; done
