#!/bin/sh
for c in $(nixos-container list); do echo "stopping: $c" && nixos-container stop $c; done
