# TODO: remove hardcoded things like hostname, username, ...
{ config, pkgs, ...}:
{
  # TODO: packages-module?
  imports = [
    ./thonkpad-hardware.nix
  ];
  boot = {
    loader = {
      # TODO: ???
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      # press Esc during boot to display menu
      # annoying, because firmware also does stuff when you press Esc,
      # so this has to be timed right
      timeout = 0;
    };
    kernel.sysctl = {
      "kernel.sysrq" = 1;
    };
    # TODO: something
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # TODO: to hardware config?
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  networking = {
    hostName = "thonkpad";
    networkmanager.enable = true;
    # TODO: remove (deprecated)
    useDHCP = false;
    interfaces = {
      enp2s0.useDHCP = true;
      wlp3s0.useDHCP = true;
    };
  };
  # TODO: internalisation
  time.timeZone = "Europe/Helsinki";
  # TODO: SUID wrappers? firewall? printing?
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    layout = "us";
    xkbVariant = "altgr-intl";
    xkbOptions = "caps:swapescape";

    libinput = {
      enable = true;
      touchpad.tapping = false;
      touchpad.disableWhileTyping = true;
    };

    # so basically this is a hack to get i3 to show up as a session
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };

    # TODO: autoLogin?
  };

  users.users.testuser = {
    isNormalUser = true;
    extraGroups = [ "wheel" "network-manager" ];
  };
  system.stateVersion = "21.03"; # Did you read the comment? I didn't.
}

