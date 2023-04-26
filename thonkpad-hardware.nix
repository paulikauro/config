{ config, lib, pkgs, modulesPath, theUsername, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ ];
      luks.devices.notroot = {
        device = "/dev/nvme1n1";
        header = "/dev/disk/by-uuid/513711c2-54bf-467d-bb9d-4d99cf93d4ce";
        keyFile = "/dev/disk/by-partuuid/dde9cf5b-ee24-9e41-8afd-3e323e39e7ab";
        keyFileSize = 64;
        # this is in the header, but whatever
        allowDiscards = true;
      };
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" =
    { device = "none";
      fsType = "tmpfs";
      # size?
      options = [ "defaults" "noatime" "mode=755" ];
    };

    "/boot" =
    { device = "/dev/nvme0n1p4";
      fsType = "vfat";
    };

    "/nix" =
    { device = "/dev/disk/by-uuid/c0bbd265-adbd-4957-911d-bab29592f613";
      fsType = "btrfs";
      options = [ "noatime" "subvol=nix" ];
      neededForBoot = true;
    };

    "/persist" =
    { device = "/dev/disk/by-uuid/c0bbd265-adbd-4957-911d-bab29592f613";
      fsType = "btrfs";
      options = [ "noatime" "subvol=persist" ];
      neededForBoot = true;
    };

    "/local" =
    { device = "/dev/disk/by-uuid/c0bbd265-adbd-4957-911d-bab29592f613";
      fsType = "btrfs";
      options = [ "noatime" "subvol=local" ];
      neededForBoot = true;
    };

    "/var/log" =
    { device = "/dev/disk/by-uuid/c0bbd265-adbd-4957-911d-bab29592f613";
      fsType = "btrfs";
      options = [ "noatime" "subvol=log" ];
    };

    "/tmp" =
    { device = "/dev/disk/by-uuid/c0bbd265-adbd-4957-911d-bab29592f613";
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
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0f3u1u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
