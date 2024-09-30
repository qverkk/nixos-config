{ pkgs, ... }:
let
  devTemplate = pkgs.writeShellScriptBin "dev-template" ''
    nix flake init --template github:the-nix-way/dev-templates#$1
  '';
in
{
  environment.systemPackages = with pkgs; [ devTemplate ];
}
