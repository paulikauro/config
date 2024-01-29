{ config, lib, pkgs, mobile-nixos, theUsername, ... }:

{
  imports = [
    (import "${mobile-nixos}/lib/configuration.nix" { device = "pine64-pinephonepro"; })
  ];
  fileSystems = {
    "/" = {
      device = "/dev/mapper/root";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/9f160105-8dae-40cd-91a6-bf2a44d4610b";
      fsType = "ext4";
    };
  };

  # no pls, systemd pls
  mobile.boot.stage-1.enable = false;

  boot.initrd = {
    luks.devices = {
      "root" = {
        device = "/dev/disk/by-uuid/b9de127f-a549-4e2f-a521-b0b607abb155";
      };
    };
    unl0kr.enable = true;

    systemd.enable = true;
  };
  boot.loader = {
    grub.enable = false;
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = false;
    # generic-extlinux-compatible.enable = true;
  };

  nix.settings.max-jobs = 3; # mkDefault?

  networking.hostName = "tunkki";
  services.openssh.enable = true; # TODO

  environment.systemPackages = with pkgs; [ neovim git file ];

  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  #hardware.pulseaudio.enable = true;
  #hardware.bluetooth.enable = true;
  #hardware.pulseaudio.package = pkgs.pulseaudioFull;

  powerManagement.enable = true;
  zramSwap.enable = true;

  users.users.${theUsername} = {
    isNormalUser = true;
    description = theUsername;
    extraGroups = [
      "dialout"
      "feedbackd"
      "networkmanager"
      "video"
      "wheel"
    ];
  };

}
