{ pkgs, lib, ... }:
{
  boot = {
    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
      "vfio_iommu_type1.allow_unsafe_interrupts=1"
      "kvm.ignore_msrs=1"
    ];
  };

  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        runAsRoot = true;
        ovmf.enable = true;
        verbatimConfig = ''
          user = "qverkk"
          group = "kvm"
          namespaces = []
        '';
      };
    };
  };

  programs = {
    dconf.enable = true;
    virt-manager.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      virt-manager
      killall

      spice
      spice-gtk
      spice-protocol
      virt-viewer
      virtio-win
      win-spice
      virtualbox
      distrobox
    ];
    shellAliases = {
      vm-start = "virsh start Windows";
      vm-stop = "virsh shutdown Windows";
    };
  };

  users.users.qverkk.extraGroups = [
    "kvm"
    "libvirtd"
  ];

  systemd.services.libvirt-sleep = {
    enable = true;
    serviceConfig = {
      ExecStart = ''systemd-inhibit --what=sleep --why="Libvirt domain \"%i\" is running" --who=%U --mode=block sleep infinity'';
    };
  };

  virtualisation.libvirtd.hooks.qemu = {
    "passthrough" = lib.getExe (
      pkgs.writeShellApplication {
        name = "qemu-hook";

        runtimeInputs = with pkgs; [
          libvirt
          systemd
          kmod
        ];

        text = ''
                    GUEST_NAME="$1"
                    OPERATION="$2"
                    if [ "$GUEST_NAME" == "win10" ]; then
                      if [ "$OPERATION" == "prepare" ]; then
          			  systemctl start libvirt-sleep
                        systemctl stop display-manager.service
          		      while systemctl is-active --quiet "display-manager.service"; do
                          sleep 2
                        done
                        modprobe -r -a nvidia_uvm nvidia_drm nvidia nvidia_modeset
                        ${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_01_00_0
                        ${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_01_00_1
                        systemctl set-property --runtime -- user.slice AllowedCPUs=14-19
                        systemctl set-property --runtime -- system.slice AllowedCPUs=14-19
                        systemctl set-property --runtime -- init.scope AllowedCPUs=14-19
                        modprobe vfio
                        modprobe vfio_pci
                        modprobe vfio_iommu_type1
                      fi
                      if [ "$OPERATION" == "release" ]; then
                        modprobe -r vfio_pci
                        modprobe -r vfio_iommu_type1
                        modprobe -r vfio
          			  systemctl stop libvirt-sleep
                        systemctl set-property --runtime -- user.slice AllowedCPUs=0-19
                        systemctl set-property --runtime -- system.slice AllowedCPUs=0-19
                        systemctl set-property --runtime -- init.scope AllowedCPUs=0-19
                        ${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_01_00_0
                        ${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_01_00_1
                        modprobe -a nvidia_uvm nvidia_drm nvidia nvidia_modeset
                        systemctl start display-manager.service
                      fi
                    fi
        '';
      }
    );
  };

  systemd.tmpfiles.rules = [
    # "L+ /var/lib/libvirt/hooks/qemu - - - - ${qemuHook}"
    "L+ /var/lib/libvirt/qemu/Windows.xml - - - - ${./Windows.xml}"
  ];
}
