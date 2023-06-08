#!/bin/sh
pushd ~/Documents/nixos

if [[ -z $1 ]]; then
    user=$(whoami)
    host=$(hostname)
    nix build .#homeConfigurations."$user@$host".activationPackage
else
    nix build .#homeConfigurations.$1.activationPackage
fi

./result/activate
popd
