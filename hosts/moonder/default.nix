{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../substituters.nix
    inputs.agenix.darwinModules.default
    ../../modules/programs/general/aerospace/darwin.nix
    ../../modules/programs/general/caddy/darwin.nix
    ../../modules/programs/general/tailscale/darwin.nix
    ../../modules/programs/development/podman/darwin.nix
  ];

  networking = {
    computerName = "moonder";
    hostName = "moonder";
    localHostName = "moonder";
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  nix = {
    package = pkgs.nixVersions.stable;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      trusted-users = [
        "root"
        "qverkk"
      ];

      max-jobs = "auto";
      cores = 0;
      keep-outputs = true;
      keep-derivations = true;
      connect-timeout = 5;
      download-attempts = 3;
    };

    extraOptions = ''
      min-free = ${toString (1024 * 1024 * 1024)}
      max-free = ${toString (5 * 1024 * 1024 * 1024)}
    '';

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 3;
        Minute = 15;
      };
      options = "--delete-older-than 7d";
    };
  };

  programs.zsh.enable = true;

  users.users.qverkk = {
    home = "/Users/qverkk";
    shell = pkgs.zsh;
  };

  environment = {
    shells = [ pkgs.zsh ];
    systemPackages = with pkgs; [
      fd
      fzf
      git
      gnused
      ripgrep
    ];
  };

  homebrew = {
    enable = true;
    brews = [ "mas" ];
    masApps = {
      WireGuard = 1451685025;
    };
  };

  system = {
    primaryUser = "qverkk";
    stateVersion = 6;

    checks.verifyNixPath = false;

    defaults = {
      LaunchServices.LSQuarantine = false;

      NSGlobalDomain = {
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.sound.beep.volume" = 0.0;
      };

      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        expose-animation-duration = 0.0;
        launchanim = false;
        mineffect = "scale";
        mouse-over-hilite-stack = true;
        orientation = "bottom";
        show-recents = false;
        tilesize = 48;
      };

      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "clmv";
        _FXShowPosixPathInTitle = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
}
