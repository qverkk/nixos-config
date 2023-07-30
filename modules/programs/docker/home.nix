{ pkgs, ... }: {
  home.file.".config/docker".source = ./configurations;
}
