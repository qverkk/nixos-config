{
  config,
  ...
}:
let
  primaryUser = config.system.primaryUser;
  userHome = config.users.users.${primaryUser}.home or "/Users/${primaryUser}";
  podmanSocket = "${userHome}/.local/share/containers/podman/machine/podman-machine-default/podman.sock";
in
{
  environment.variables = {
    DOCKER_HOST = "unix://${podmanSocket}";
    TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
    TESTCONTAINERS_RYUK_DISABLED = "true";
  };

  environment.shellAliases = {
    docker = "podman";
  };

  homebrew.brews = [
    "podman"
    "podman-compose"
  ];

  homebrew.casks = [
    "podman-desktop"
  ];

  home-manager.users.${primaryUser}.home.file.".testcontainers.properties".text = ''
    docker.host=unix://${podmanSocket}
  '';
}
