{ config, hostName, ... }:
{
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = false;
      db_path = "${config.home.homeDirectory}/atuin-history/${hostName}/atuin-${hostName}-history.db";
    };
  };
}
