# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
      luks.devices."notroot" = {
        device = "/dev/disk/by-uuid/afa70514-b57e-42a8-be0d-f2635bb88580";
        allowDiscards = true;
      };
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" =
    { device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "noatime" "mode=755" ];
    };

  "/boot" =
    { device = "/dev/disk/by-uuid/97AE-3F76";
      fsType = "vfat";
    };

    "/nix" =
    { device = "/dev/disk/by-uuid/49633c2c-82ca-4fa9-82a1-1b7d68f50ca5";
      fsType = "btrfs";
      options = [ "noatime" "subvol=nix" ];
      neededForBoot = true;
    };

  "/persist" =
    { device = "/dev/disk/by-uuid/49633c2c-82ca-4fa9-82a1-1b7d68f50ca5";
      fsType = "btrfs";
      options = [ "noatime" "subvol=persist" ];
      neededForBoot = true;
    };

  "/local" =
    { device = "/dev/disk/by-uuid/49633c2c-82ca-4fa9-82a1-1b7d68f50ca5";
      fsType = "btrfs";
      options = [ "noatime" "subvol=local" ];
      neededForBoot = true;
    };

  "/tmp" =
    { device = "/dev/disk/by-uuid/49633c2c-82ca-4fa9-82a1-1b7d68f50ca5";
      fsType = "btrfs";
      options = [ "noatime" "subvol=tmp" "nosuid" "nodev" "mode=1777" ];
    };
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

