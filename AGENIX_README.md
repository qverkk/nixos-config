Run this to encrypt new agenix files

export RULES=~/Documents/nixos/secrets/secrets.nix && EDITOR=vim && nix run github:ryantm/agenix -- -e file.age -i ~/.ssh/nixos-desktop
