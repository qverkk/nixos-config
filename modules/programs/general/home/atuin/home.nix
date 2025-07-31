{ config, hostName, ... }:
{
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = false;
      db_path = "/home/qverkk/atuin-history/${hostName}/atuin-${hostName}-history.db";
    };
  };
}
