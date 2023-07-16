{pkgs, ...}: {
  # users.users.qverkk.extraGroups = [ "freshrss" ];
  services.freshrss = {
    enable = true;
    baseUrl = "http://localhost";
    passwordFile = "/home/qverkk/.config/freshrss/credentials.txt";
    # dataDir = "/home/qverkk/.config/freshrss";
    virtualHost = "localhost";
  };
}
