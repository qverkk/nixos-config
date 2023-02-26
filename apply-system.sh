#!/bin/sh
pushd ~/Documents/nixos
sudo nixos-rebuild switch --flake .#
popd
