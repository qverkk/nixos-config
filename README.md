# Installation

## 1. Disk formatting

Follow : https://nixos.wiki/wiki/NixOS_Installation_Guide
- Make 1 boot partition
- Make 1 ext4 partition
- Label them
- Mount them

```
g (gpt disk label)
n
1 (partition number [1/128])
2048 first sector
+500M last sector (boot sector size)
t
1 (EFI System)
n
2
default (fill up partition)
default (fill up partition)
w (write)

lsblk
sudo mkfs.fat -F 32 /dev/sdX1
sudo fatlabel /dev/sdX1 NIXBOOT
sudo mkfs.ext4 /dev/sdX2 -L NIXROOT
sudo mount /dev/disk/by-label/NIXROOT /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/NIXBOOT /mnt/boot    
```

## 2. Generatre nixos config
nixos-generate-config --root /mnt

## 3. Clone this repository
```
nix-shell -p git
git clone  https://github.com/qverkk/nixos-config.git /mnt/etc/nixos/Flakes 
cd /mnt/etc/nixos/Flakes/
nix develop --extra-experimental-features nix-command --extra-experimental-features flakes
```

## 4. Setup new host
If this installation is a new host perform the following:
1. `cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/Flakes/hosts/NEWHOSTNAME/hardware-configuration.nix`
2. Copy default.nix from one of the existing hosts and adjust it for your needs
3. Remove Agenix possibly??
4. Add a new home configuration in the home directory `newhostname.nix`
- Adjust the monitor setup, you can get your current monitor info via xrandr (xorg) or wlr-randr (wayland)
5. Add new host info into flake.nix 
- Add a new home configuration 
- Add a new nixos configuration

## 5. Prepare for installation
rm -rf .git

## 6. Install the os
While being in the /mnt/etc/nixos/Flakes perform the following:
nixos-install --flake .#hostName

While installation, it will ask for a new root pass, set it.

## 7. Login into the os

Either:
- username: yourusername
- password: password (or it may be empty idk)

Or:
- username: root
- password: password
- And change the password of ur user
- Logout and login to ur user

## 8. Clone repo once again
git clone https://github.com/qverkk/nixos-config.git ~/Documents/nixos

## 9. Load user home-manager
~/Documents/nixos/apply-user.sh

## 10. Done, login to your desktop
For me it's Hyprland, so i'm just executing Hyprland in tty

