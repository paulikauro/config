{ pkgs, lib, theUsername, ... }:
{
  boot = {
    loader = {
      # lanzaboote replaces systemd-boot
      systemd-boot.enable = lib.mkForce false;
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
      # set by stylix?
      # theme = "breeze";
    };
    consoleLogLevel = 0;
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    # TODO: something
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    supportedFilesystems = [ "ntfs" "btrfs" ];
    bootspec.enable = true;
    lanzaboote = {
      enable = true;
      # automatic enrollment of keys might brick some motherboards
      # so enroll them through firmware to be safe
      enrollKeys = false;
      pkiBundle = "/etc/secureboot";
    };
  };

  powerManagement.cpuFreqGovernor = "performance";

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
    libvirtd.enable = true;
  };

  networking.networkmanager.enable = true;
  # network manager has its own dhcp client
  # dhcpcd just slows down shutdowns
  networking.useDHCP = false;
  # TODO: internalisation
  time.timeZone = "Europe/Helsinki";
  # TODO: SUID wrappers? firewall? printing?
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
  # this can have unforeseen consequences but we're setting it anyway!!!
  environment.sessionVariables.GTK_USE_PORTAL = "1";

  hardware.enableRedistributableFirmware = true;

  programs = {
    adb.enable = true;
    steam.enable = true;
    wireshark.enable = true;
  };

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        capslock = "overload(control, esc)";
        esc = "capslock";
      };
    };
  };

  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "95"; }
    { domain = "@audio"; item = "nice"; type = "-"; value = "-19"; }
    # todo: wtf, 1048576 not enough
    # { domain = "*"; item = "nofile"; type = "-"; value = "unlimited"; }
  ];

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
    pulse.enable = true;
    socketActivation = true;
  };

  hardware.graphics.enable = true;

  hardware.openrazer = {
    enable = true;
    users = [ theUsername ];
  };

  security.sudo = {
    enable = true;
    # disable lecture, since otherwise it is shown once after every boot,
    # since lectured users are not persisted (/var/db/sudo/lectured/<user>)
    extraConfig = ''
    Defaults lecture = never
    '';
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666"
  '';

  services.libinput = {
    enable = true;
    touchpad.tapping = false;
    touchpad.disableWhileTyping = true;
  };

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    xkb = {
      variant = "altgr-intl";
      layout = "us";
    };


    # so basically this is a hack to get i3 to show up as a session
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
    };

    # TODO: autoLogin?
  };

  users.mutableUsers = false;
  users.users.${theUsername} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "network-manager" "adbusers" "dialout" "audio" "libvirtd" ];
    # it's hashed
    hashedPasswordFile = "/local/password";
  };
  # lock root password
  users.users.root.hashedPassword = "!";
}
