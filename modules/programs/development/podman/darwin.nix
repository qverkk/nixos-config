{ ... }:
{
  environment.variables = {
    DOCKER_HOST = "unix://$HOME/.local/share/containers/podman/machine/podman-machine-default/podman.sock";
    TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
    TESTCONTAINERS_RYUK_DISABLED = "true";
  };

  environment.shellAliases = {
    docker = "podman";
  };

  homebrew.casks = [
    "podman-desktop"
  ];
}
