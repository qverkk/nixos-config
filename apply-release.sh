#!/bin/sh
pushd ~/Documents/nixos
sudo nixos-rebuild boot  --flake .#
popd
