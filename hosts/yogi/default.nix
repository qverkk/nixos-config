# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.agenix.nixosModules.default
    inputs.nur.nixosModules.nur
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.auto-cpufreq.nixosModules.default
    ../../modules/hardware/bluetooth.nix
    ../../modules/hardware/openrazer.nix
    ../../modules/hardware/onlykey.nix
    ../../modules/hardware/qmk.nix
    ../../modules/programs/moonlander
    ../../modules/programs/general/tailscale
    ../../modules/programs/general/zsh
    ../../modules/desktop/sway
    # ../../modules/desktop/hyprland
    ../../modules/programs/development/podman
    ../../modules/programs/development/shell-scripts
    ../../modules/programs/general/brave
  ];

  programs.auto-cpufreq = {
    enable = false;

    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };

      battery = {
        governor = "powersave";
        turbo = "never";
      };
    };
  };

  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_6_10;
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = false;
      };
    };
  };

  networking = {
    hostName = "yogi"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Enable networking
    networkmanager.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
    firewall = {
      enable = true;
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  i18n = {
    # Select internationalisation properties.
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_MEASUREMENT = "pl_PL.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_NAME = "pl_PL.UTF-8";
      LC_NUMERIC = "pl_PL.UTF-8";
      LC_PAPER = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_TIME = "pl_PL.UTF-8";
    };
  };

  services = {
    # Configure keymap in X11
    xserver.xkb = {
      layout = "pl";
      variant = "";
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.qverkk = {
    isNormalUser = true;
    description = "qverkk";
    extraGroups = ["networkmanager" "wheel" "podman" "openrazer"];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    fd
    ripgrep
    neovim
  ];

  nix = {
    package = pkgs.nixFlakes;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      auto-optimise-store = true
    '';
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
