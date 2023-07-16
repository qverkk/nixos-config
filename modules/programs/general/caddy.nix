{
  pkgs,
  lib,
  config,
  ...
}: let
  app = "qverkk";
in {
  services.phpfpm = {
    phpOptions = ''
      date.timezone = "Europe/Berlin"
      ;memory_limit = 256M
      ;max_execution_time = 60

      zend_extension = ${pkgs.php}/lib/php/extensions/opcache.so
      opcache.enable = 1
      opcache.memory_consumption = 64
      opcache.interned_strings_buffer = 16
      opcache.max_accelerated_files = 10000
      opcache.max_wasted_percentage = 5
      opcache.use_cwd = 1
      opcache.validate_timestamps = 1
      opcache.revalidate_freq = 2
      opcache.fast_shutdown = 1
    '';

    pools.${app} = {
      user = "qverkk";
      group = "users";
      settings = {
        "listen.owner" = "qverkk";
        "listen.group" = "users";
        "listen" = "0.0.0.0:9000";
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.max_requests" = 500;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 5;
        "php_admin_value[error_log]" = "stderr";
        "php_admin_flag[log_errors]" = true;
        "catch_workers_output" = true;
      };
      # phpEnv."PATH" = lib.makeBinPath [pkgs.php];
    };
  };
  services.caddy = {
    enable = true;

    virtualHosts."full-text-rss".extraConfig = ''
      respond "hello"
    '';

    # virtualHosts."localhost".extraConfig = ''
    #         root    * /var/www
    #         encode gzip
    #         php_fastcgi localhost:9000
    #   file_server

    # '';
  };

  # environment.systemPackages = with pkgs; [vnstat php];
}
