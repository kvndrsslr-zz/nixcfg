#!/bin/sh
for c in $(nixos-container list); do echo "$c: $(nixos-container status $c)"; done
