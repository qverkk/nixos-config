{ pkgs, config, ... }:
{
  services.freshrss = {
    enable = true;
    defaultUser = "qverkk";
    baseUrl = "https://freshrss";
    passwordFile = config.age.secrets.freshrss.path;
    dataDir = "/var/lib/freshrss";
    virtualHost = "freshrss";
  };

  # services.phpfpm.pools.freshrss.settings = {
  #   # use the provided phpfpm pool, but override permissions for caddy
  #   "listen.owner" = lib.mkForce "caddy";
  #   "listen.group" = lib.mkForce "caddy";
  # };

  networking.extraHosts = "127.0.0.3 freshrss.local";
}
