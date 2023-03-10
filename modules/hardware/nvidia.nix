{ config, lib, pkgs, ... }:

let
  extraEnv = {
    WLR_NO_HARDWARE_CURSORS = "1";
    XWAYLAND_NO_GLAMOR = "1";
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
    services = {
      xserver.videoDrivers = [ "nvidia" ];
    };

    environment.variables = extraEnv;
    environment.sessionVariables = extraEnv;

    hardware = {
      nvidia = {
        modesetting.enable = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        powerManagement.enable = false;
        prime = {
          offload.enable = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };

      opengl = {
        enable = true;
        driSupport = true;
        extraPackages = with pkgs; [
          vaapiVdpau
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
