{ pkgs
, config
, ...
}: {
  services.freshrss = {
    enable = true;
    defaultUser = "qverkk";
    baseUrl = "https://freshrss";
    passwordFile = config.age.secrets.freshrss.path;
    dataDir = "/var/lib/freshrss";
    virtualHost = "freshrss";
  };

  networking.extraHosts = "127.0.0.3 freshrss.local";
}
