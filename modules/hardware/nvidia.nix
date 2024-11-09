{
  config,
  pkgs,
  lib,
  ...
}:
let
  extraEnv = {
    WLR_NO_HARDWARE_CURSORS = "1";
    XWAYLAND_NO_GLAMOR = "1";
    # This has to be disabled in order to get hyprland working
    # WLR_RENDERER = "vulkan";
    # WLR_DRM_DEVICES = "/dev/dri/card1";
    GBM_BACKEND = "nvidia-drm";
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  config = {
    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];

    boot.kernelModules = [
      "nvidia"
      "nvidia_drm"
      "nvidia_uvm"
    ];

    services = {
      xserver.videoDrivers = [ "nvidia" ];
    };

    environment.variables = extraEnv;
    environment.sessionVariables = extraEnv;

    hardware = {
      nvidia = {
        modesetting.enable = true;

        # The nvidia-settings build is currently broken due to a missing
        # vulkan header; re-enable whenever
        # 0384602eac8bc57add3227688ec242667df3ffe3the hits stable.
        nvidiaSettings = true;

        # package = config.boot.kernelPackages.nvidiaPackages.beta;
        package =
          (config.boot.kernelPackages.nvidiaPackages.mkDriver {
            # version = "555.58";
            # sha256_64bit = "sha256-bXvcXkg2kQZuCNKRZM5QoTaTjF4l2TtrsKUvyicj5ew=";
            # sha256_aarch64 = "sha256-7XswQwW1iFP4ji5mbRQ6PVEhD4SGWpjUJe1o8zoXYRE=";
            # openSha256 = "sha256-hEAmFISMuXm8tbsrB+WiUcEFuSGRNZ37aKWvf0WJ2/c=";
            # settingsSha256 = "sha256-vWnrXlBCb3K5uVkDFmJDVq51wrCoqgPF03lSjZOuU8M=";
            # persistencedSha256 = "sha256-lyYxDuGDTMdGxX3CaiWUh1IQuQlkI2hPEs5LI20vEVw=";

            version = "560.35.03";
            sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
            sha256_aarch64 = "sha256-s8ZAVKvRNXpjxRYqM3E5oss5FdqW+tv1qQC2pDjfG+s=";
            openSha256 = "sha256-/32Zf0dKrofTmPZ3Ratw4vDM7B+OgpC4p7s+RHUjCrg=";
            settingsSha256 = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
            persistencedSha256 = "sha256-E2J2wYYyRu7Kc3MMZz/8ZIemcZg68rkzvqEwFAL3fFs=";

            # version = "555.58.02";
            # sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
            # sha256_aarch64 = "sha256-wb20isMrRg8PeQBU96lWJzBMkjfySAUaqt4EgZnhyF8=";
            # openSha256 = "sha256-8hyRiGB+m2hL3c9MDA/Pon+Xl6E788MZ50WrrAGUVuY=";
            # settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
            # persistencedSha256 = "sha256-a1D7ZZmcKFWfPjjH1REqPM5j/YLWKnbkP9qfRyIyxAw=";
          }).overrideAttrs
            (oldAttrs: {
              passthru = oldAttrs.passthru // {
                settings = oldAttrs.passthru.settings.overrideAttrs (oldAttrsSettings: {
                  buildInputs = oldAttrsSettings.buildInputs ++ [ pkgs.vulkan-headers ];
                });
              };
            });
        powerManagement.enable = false;
        open = false;
        # prime = {
        #   offload.enable = true;
        #   intelBusId = "PCI:0:2:0";
        #   nvidiaBusId = "PCI:1:0:0";
        # };
      };

      graphics = {
        # enable = true;
        # driSupport = true;
        extraPackages = with pkgs; [
          vaapiVdpau
          vulkan-validation-layers
          nvidia-vaapi-driver
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      glxinfo
      vulkan-tools
      glmark2
      nvidia-offload
    ];
  };
}
