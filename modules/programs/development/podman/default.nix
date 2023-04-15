{ pkgs, ... }:

let
  dockerStart = pkgs.writeShellScriptBin "docker-start" ''
    systemctl --user start podman.socket
    systemctl --user start podman
  '';

  dockerStop = pkgs.writeShellScriptBin "docker-stop" ''
    systemctl --user stop podman.socket
    systemctl --user stop podman
  '';
in
{
  # podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.dnsname.enable = true;
  };

  environment.systemPackages = with pkgs; [
    podman-compose
    podman-tui
    dockerStart
    dockerStop
  ];
}
