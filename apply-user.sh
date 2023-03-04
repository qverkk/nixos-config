#!/bin/sh
pushd ~/Documents/nixos
nix build .#homeConfigurations.qverkk.activationPackage
./result/activate
popd
