{
  pkgs,
  config,
  lib,
  ...
}: {
  services.freshrss = {
    enable = true;
    defaultUser = "qverkk";
    baseUrl = "http://freshrss.localhost";
    passwordFile = config.age.secrets.freshrss.path;
    dataDir = "/var/lib/freshrss";
    virtualHost = null;
    package = pkgs.freshrss.overrideAttrs (old: {
      overrideConfig = pkgs.writeText "constants.local.php" ''
        <?php
              define('DATA_PATH', getenv('FRESHRSS_DATA_PATH'));
              define('THIRDPARTY_EXTENSIONS_PATH', getenv('FRESHRSS_DATA_PATH') . '/extensions');
              define('EXTENSIONS_PATH', getenv('FRESHRSS_DATA_PATH') . '/extensions');
      '';
    });
  };

  services.phpfpm.pools.freshrss.settings = {
    # use the provided phpfpm pool, but override permissions for caddy
    "listen.owner" = lib.mkForce "caddy";
    "listen.group" = lib.mkForce "caddy";
  };

  networking.extraHosts = "127.0.0.3 freshrss.local";
}
