{pkgs, ...}: {
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    "fullfeedrss" = {
      image = "heussd/fivefilters-full-text-rss:latest";
      environment = {
        "FTR_ADMIN_PASSWORD" = "";
      };
      volumes = ["/home/qverkk/.rsscache:/var/www/html/cache"];
      ports = ["127.0.0.1:8080:80"];
      autoStart = true;
    };
  };
}
