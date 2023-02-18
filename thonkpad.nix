# TODO: remove hardcoded things like hostname, username, ...
{ config, pkgs, ... }:
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
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    plymouth = {
      enable = true;
      theme = "breeze";
    };
    consoleLogLevel = 0;
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    # TODO: something
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "ntfs" ];
    tmpOnTmpfs = true;
  };

  hardware.amdgpu = {
    # this failed to compile shaders for whatever reason
    amdvlk = false;
    # this seems to be the default but to be explicit
    loadInInitrd = true;
  };

  # amd pstate?
  # fingerprint reader usb id 27c6:55a4

  powerManagement.cpuFreqGovernor = "performance";

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

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
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };

  hardware.enableRedistributableFirmware = true;

  programs.adb.enable = true;
  programs.steam.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.enable = true;

  hardware.openrazer = {
    enable = true;
    users = [ "testuser" ];
  };

  #services.pipewire = {
  #  enable = true;
  #  alsa = {
  #    enable = true;
  #    support32Bit = true;
  #  };
  #  jack.enable = true;
  #  pulse.enable = true;
  #  socketActivation = true;
  #};

  # todo: configure this
  services.input-remapper.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666"
  '';

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    layout = "us";
    xkbVariant = "altgr-intl";
    xkbOptions = "caps:escape";

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
    extraGroups = [ "wheel" "network-manager" "adbusers" "dialout" ];
  };
  system.stateVersion = "21.03"; # Did you read the comment? I didn't.
}

