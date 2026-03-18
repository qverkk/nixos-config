{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.stable;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      warn-dirty = false;
      trusted-users = [
        "root"
        "qverkk"
      ];

      # Build parallelism
      max-jobs = "auto";
      cores = 0; # 0 = all cores per derivation

      # Keep build deps for faster rebuilds
      keep-outputs = true;
      keep-derivations = true;

      # Cache tuning
      connect-timeout = 5;
      download-attempts = 3;
    };

    # On-demand GC during builds
    extraOptions = ''
      min-free = ${toString (1024 * 1024 * 1024)}
      max-free = ${toString (5 * 1024 * 1024 * 1024)}
    '';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
