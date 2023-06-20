{
  pkgs,
  self,
  ...
}: {
  boot = {
    kernelParams = ["intel_iommu=on" "iommu=pt" "vfio_iommu_type1.allow_unsafe_interrupts=1" "kvm.ignore_msrs=1"];
  };

  virtualisation = {
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

  environment = {
    systemPackages = [
      pkgs.virt-manager
	  pkgs.killall
    ];
    shellAliases = {
      vm-start = "virsh start Windows";
      vm-stop = "virsh shutdown Windows";
    };
  };

  users.users.qverkk.extraGroups = ["kvm" "libvirtd"];

  systemd.tmpfiles.rules = let
    qemuHook = pkgs.writeShellScript "qemu-hook" ''
        GUEST_NAME="$1"
        OPERATION="$2"
        SUB_OPERATION="$3"

        if [ "$GUEST_NAME" == "WindowsTemp" ]; then
          if [ "$OPERATION" == "prepare" ]; then
      		modprobe -r -a nvidia_uvm nvidia_drm nvidia nvidia_modeset
      		${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_01_00_0
      		${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_01_00_1
      		systemctl set-property --runtime -- user.slice AllowedCPUs=14-19
      		systemctl set-property --runtime -- system.slice AllowedCPUs=14-19
      		systemctl set-property --runtime -- init.scope AllowedCPUs=14-19
          fi
          if [ "$OPERATION" == "release" ]; then
      		systemctl set-property --runtime -- user.slice AllowedCPUs=0-19
      		systemctl set-property --runtime -- system.slice AllowedCPUs=0-19
      		systemctl set-property --runtime -- init.scope AllowedCPUs=0-19
      		${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_01_00_0
      		${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_01_00_1
      		modprobe -a nvidia_uvm nvidia_drm nvidia nvidia_modeset
          fi
        fi
    '';
  in [
    "L+ /var/lib/libvirt/hooks/qemu - - - - ${qemuHook}"
    "L+ /var/lib/libvirt/qemu/Windows.xml - - - - ${./Windows.xml}"
  ];
}
