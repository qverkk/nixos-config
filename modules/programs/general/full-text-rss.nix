{ pkgs, ... }: {
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    "fullfeedrss" = {
      image = "heussd/fivefilters-full-text-rss:latest";
      environment = {
        "FTR_ADMIN_PASSWORD" = "";
      };
      volumes = [ "rss-cache:/var/www/html/cache" ];
      ports = [ "9999:80" ];
      autoStart = true;
    };
  };
}
