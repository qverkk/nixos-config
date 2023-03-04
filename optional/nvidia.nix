{ config, lib, pkgs, ... }:

let
  extraEnv = { WLR_NO_HARDWARE_CURSORS = "1"; };
in
{

  config = { 
    environment.variables = extraEnv;
    environment.sessionVariables = extraEnv;

    environment.systemPackages = with pkgs; [
      glxinfo
      vulkan-tools
      glmark2
    ];

    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    hardware.nvidia.powerManagement.enable = false;
    hardware.opengl.enable = true;

    services.xserver = {
      videoDrivers = [ "nvidia" ];
    };
  };

  #hardware.nvidia.package = config.boot.kernelPackages.nvidia_x11;
}
