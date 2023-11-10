{
  pkgs,
  config,
  ...
}: {
  services.caddy = {
    enable = true;

    virtualHosts."full-text-rss.localhost" = {
      extraConfig = ''
        reverse_proxy localhost:9907
      '';
      listenAddresses = ["127.0.0.1"];
    };

    virtualHosts."wallabag.localhost" = {
      extraConfig = ''
        reverse_proxy localhost:9908
      '';
      listenAddresses = ["127.0.0.1"];
    };

    virtualHosts."syncthing.localhost" = {
      extraConfig = ''
        reverse_proxy localhost:8384
      '';
      listenAddresses = ["127.0.0.1"];
    };

    virtualHosts."matrix.localhost" = {
      extraConfig = ''
        reverse_proxy localhost:8849
      '';
      listenAddresses = ["127.0.0.1"];
    };

    virtualHosts."freshrss.localhost" = {
      extraConfig = ''
        root * ${pkgs.freshrss}/p
        php_fastcgi unix/${config.services.phpfpm.pools.freshrss.socket} {
            env FRESHRSS_DATA_PATH ${config.services.freshrss.dataDir}
        }
        file_server
      '';
      listenAddresses = ["127.0.0.1"];
    };
  };
}
