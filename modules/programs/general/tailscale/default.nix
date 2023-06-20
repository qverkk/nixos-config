{
  config,
  pkgs,
  ...
}: {
  # make the tailscale command usable to users
  environment.systemPackages = [pkgs.tailscale];

  # enable the tailscale service
  services.tailscale.enable = true;

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    allowedTCPPorts = [ 22 ];
  };
}
