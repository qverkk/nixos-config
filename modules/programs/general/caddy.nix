{ pkgs, ... }: {
  services.caddy = {
    enable = true;

    virtualHosts."full-text-rss.localhost" = {
      extraConfig = ''
        reverse_proxy localhost:9907
      '';
      listenAddresses = [ "127.0.0.1" ];
    };

    virtualHosts."syncthing.localhost" = {
      extraConfig = ''
        reverse_proxy localhost:8384
      '';
      listenAddresses = [ "127.0.0.1" ];
    };

    virtualHosts."freshrss.localhost" = {
      extraConfig = ''
        reverse_proxy freshrss.local
      '';
      listenAddresses = [ "127.0.0.1" ];
    };
  };
}
