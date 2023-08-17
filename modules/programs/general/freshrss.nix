{
  pkgs,
  config,
  ...
}: {
  services.freshrss = {
    enable = true;
    defaultUser = "qverkk";
    baseUrl = "https://freshrss";
    passwordFile = config.age.secrets.freshrss.path;
    dataDir = "/var/lib/freshrss";
    virtualHost = "freshrss";
    package = pkgs.freshrss.overrideAttrs (old: {
      overrideConfig = pkgs.writeText "constants.local.php" ''
        <?php
              define('DATA_PATH', getenv('FRESHRSS_DATA_PATH'));
              define('THIRDPARTY_EXTENSIONS_PATH', getenv('FRESHRSS_DATA_PATH') . '/extensions');
              define('EXTENSIONS_PATH', getenv('FRESHRSS_DATA_PATH') . '/extensions');
      '';
    });
  };

  networking.extraHosts = "127.0.0.3 freshrss.local";
}
