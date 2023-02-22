{ config, lib, pkgs, modulesPath, ... }:

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
        header = "/boot/header.img";
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
    { device = "/dev/disk/by-uuid/5850-7AA5";
      fsType = "vfat";
      neededForBoot = true;
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
      options = [ "subvol=local" ];
      neededForBoot = true;
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
