{ config, pkgs, config-dir, ... }:
with pkgs.lib;
with pkgs.lib.attrsets;
{
  # TODO:
  # - emacs service & client.. dev config? git, jetbrains tools
  # - dunst, polybar config, redshift config?
  # - ssh
  imports = [ ./development.nix ./firefox ];
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # (nerdfonts.override { fonts = ["JetBrainsMono"]; })
    # jetbrains-mono
    xfce.xfce4-terminal
    calibre
    # TODO: is this needed?
    networkmanagerapplet
    libnotify
    pavucontrol
    # libreoffice
    # TODO: move somewhere
    mupdf
    # teams
    gimp
    scrot
    xclip
    redshift
    discord
    poppler_utils
    youtube-dl
    ffmpeg
    audacity
    pcmanfm
    vlc
    # fluidsynth
    # soundfont-fluid
    # musescore
    # reaper
    ardour
    razergenie
    xorg.xev
    xcape
    tigervnc
    #rosegarden
    arandr
    djview
    feh
    simplescreenrecorder
    steam-run
    age
    xournalpp
    # zoom-us
    # wine
    # winetricks
    (retroarch.override { cores = with libretro; [ nestopia ]; })
    protontricks
    # chromium

    openssl
    openssl.dev
    nvme-cli
    kopia
    cmake
    libglvnd
    glxinfo
    lz4
    dejsonlz4
    jq
    nix-index
    prismlauncher
    cryptsetup
    openjdk11
    python3
    patchelf
    gnumake
    gcc
    glibc
    usbutils
    pciutils
    file
    lshw
    killall
    # helvum
    # guitarix
    sbctl
    dmidecode
    efibootmgr
    tpm2-tools
    unar
  ];
  xdg.configFile."keepassxc/keepassxc.ini".source = config.lib.file.mkOutOfStoreSymlink "${config-dir}/keepassxc.ini";
  home.file.".local/bin".source = ./bin;
  home.sessionPath = [ "$HOME/.local/bin" ];
  dconf.enable = true;
  services = {
    network-manager-applet.enable = true;
    polybar = {
      enable = true;
      package = pkgs.polybar.override {
        i3Support = true;
      };
      config = {
        "bar/top" = {
          bottom = false;
          modules-right = "battery date";
          tray-position = "right";
          wm-restack = "i3";
          override-redirect = true;
        };
        "module/battery" = {
          type = "internal/battery";
          battery = "BAT0";
          adapter = "AC";
        };
        "module/date" = {
          type = "internal/date";
          date = "%Y-%m-%d %H:%M";
          # time = "%H:%M";
        };
      };
      script = "polybar top &";
      # TODO: i3GapsSupport?
    };
    redshift = {
      enable = false;
      tray = true;
      temperature.night = 2000;
      latitude = "61.5";
      longitude = "23.79";
    };
    screen-locker = {
      enable = true;
      lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
      inactiveInterval = 10;
      xautolock.enable = true;
    };
    dunst = {
      enable = true;
      settings = {
        global = {
          # stylix
          # font = "JetBrains Mono 10";
          max_icon_size = 50;
        };
      };
    };
  };
  programs = {
    rofi.enable = true;
  };
  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3; # -gaps;
    extraConfig = "bindsym --release Print exec --no-startup-id ~/.local/bin/screenshot.sh";
    config =
      let
        keepassxc = (pkgs.keepassxc.override {
          # keeshare likes to clutter the config file with a public/private (!) key pair xml mess
          withKeePassKeeShare = false;
          withKeePassNetworking = false;
        });
        mod = "Mod4";
        terminal = "${pkgs.kitty}/bin/kitty";
        launcher = "${pkgs.rofi}/bin/rofi -show run";
        passwordManager = "${keepassxc}/bin/keepassxc";
        prefixWithMod = mapAttrs' (name: value: { name = "${mod}+${name}"; value = value; });
        workspaceNames = [
          "0: misc"
          "1: chat"
          "2: web"
          "3"
          "4: code"
          "5: music"
          "6"
          "7"
          "8"
          "9: games"
        ];
        workspaces = listToAttrs (imap0 (index: name: { name = toString index; value = name; }) workspaceNames);
      in
      {
        startup = [
          {
            command = "~/.local/bin/caps.sh";
            always = true;
            notification = false;
            workspace = null;
          }
        ];
        assigns = {
          "2: web" = [{ class = "^Firefox$"; }];
        };
        floating = {
          modifier = mod;
          titlebar = false;
          border = 0;
        };
        # stylix
        # fonts = [ "JetBrains Mono 10" ];
        /*gaps = {
          inner = 10;
          outer = 5;
          smartGaps = true;
        };*/
        window = {
          hideEdgeBorders = "both";
          titlebar = false;
          border = 0;
        };
        modes = { };
        bars = [ ];
        keybindings = prefixWithMod
          {
            Return = "exec ${terminal}";
            q = "kill";
            "Shift+q" = "exit";
            w = "layout tabbed";
            e = "layout toggle split";
            r = "reload";
            "Mod1+l" = "exec ${pkgs.i3lock}/bin/i3lock -c 000000";
            "Shift+r" = "restart";

            /*t = "gaps inner current plus 5";
            "Shift+t" = "gaps inner current minus 5";
            z = "gaps outer current plus 5";
            "Shift+z" = "gaps outer current minus 5";*/

            "Shift+y" = "resize shrink width 10px or 10ppt";
            "Shift+u" = "resize shrink height 10px or 10ppt";
            "Shift+i" = "resize grow height 10px or 10ppt";
            "Shift+o" = "resize grow width 10px or 10ppt";

            b = "exec --no-startup-id redshift -O 3500K";
            "Shift+b" = "exec --no-startup-id redshift -x";

            a = "focus parent";
            "Shift+a" = "focus child";

            s = "layout stacking";
            "Shift+s" = "focus mode_toggle";

            d = "exec ${launcher}";

            f = "fullscreen toggle";
            "Shift+f" = "floating toggle";

            h = "focus left";
            j = "focus down";
            k = "focus up";
            l = "focus right";

            "Shift+h" = "move left 30";
            "Shift+j" = "move down 30";
            "Shift+k" = "move up 30";
            "Shift+l" = "move right 30";

            "Shift+x" = "exec ${passwordManager}";

            v = "split v";
            "Shift+v" = "split h";
          }
        // mapAttrs' (index: name: { name = "${mod}+${index}"; value = "workspace ${name}"; }) workspaces
        // mapAttrs' (index: name: { name = "${mod}+Shift+${index}"; value = "move container to workspace ${name}"; }) workspaces;
      };
  };
}
