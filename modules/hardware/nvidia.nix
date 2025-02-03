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

            # version = "560.35.03";
            # sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
            # sha256_aarch64 = "sha256-s8ZAVKvRNXpjxRYqM3E5oss5FdqW+tv1qQC2pDjfG+s=";
            # openSha256 = "sha256-/32Zf0dKrofTmPZ3Ratw4vDM7B+OgpC4p7s+RHUjCrg=";
            # settingsSha256 = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
            # persistencedSha256 = "sha256-E2J2wYYyRu7Kc3MMZz/8ZIemcZg68rkzvqEwFAL3fFs=";

            version = "570.86.16";
            sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
            sha256_aarch64 = "sha256-RiO2njJ+z0DYBo/1DKa9GmAjFgZFfQ1/1Ga+vXG87vA=";
            openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
            settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
            persistencedSha256 = "sha256-3mp9X/oV8o2TH9720NnoXROxQ4g98nNee+DucXpQy3w=";
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
