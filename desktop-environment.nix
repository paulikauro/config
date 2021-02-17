{ config, pkgs, ...}:
with pkgs.lib;
with pkgs.lib.attrsets;
{
  # TODO:
  # - emacs service & client.. dev config? git, jetbrains tools
  # - dunst, polybar config, redshift config?
  # - ssh
  imports = [ ./development.nix ];
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # TODO: nerd fonts?
    # (nerdfonts.override { fonts = ["JetBrainsMono"]; })
    jetbrains-mono
    xfce.xfce4-terminal
    # TODO: is this needed?
    networkmanagerapplet
    keepassxc
    libnotify
    pavucontrol
    libreoffice
    # TODO: move somewhere
    texlive.combined.scheme-full
    mupdf
    teams
    gimp
    scrot
    xclip
  ];
  home.file.".local/bin".source = ./bin;
  home.sessionPath = [ "~/.local/bin" ];
  dconf.enable = true;
  services = {
    network-manager-applet.enable = true;
    polybar = {
      enable = true;
      config = {
        "bar/top" = {
          bottom = false;
          modules-left = "cpu memory";
          modules-center = "xwindow";
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
        "module/cpu" = {
          type = "internal/cpu";
        };
        "module/memory" = {
          type = "internal/memory";
        };
        "module/xwindow" = {
          type = "internal/xwindow";
        };
        "module/date" = {
          type = "internal/date";
          date = "%Y-%m-%d%";
          time = "%H:%M";
        };
      };
      script = "polybar top &";
      # TODO: i3GapsSupport?
    };
    redshift = {
      enable = true;
      tray = true;
      temperature.night = 2000;
      latitude = "61.5";
      longitude = "23.79";
    };
    xscreensaver = {
      enable = true;
      settings = {
        mode = "blank";
        lock = true;
        fade = false;
        timeout = 15;
      };
    };
    dunst = {
      enable = true;
      settings = {
        global = {
          font = "JetBrains Mono 10";
        };
      };
    };
  };
  programs = {
    rofi.enable = true;
    bash.enable = true;
    direnv.enable = true;
    firefox = {
      # TODO: dark theme
      enable = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        cookie-autodelete
        keepassxc-browser
        multi-account-containers
        ublock-origin
      ];
      profiles.default.settings = {
        "browser.bookmarks.defaultLocation" = "unfiled";
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.contentblocking.category" = "strict";
        "browser.ctrlTab.recentlyUsedOrder" = false;
        "browser.discovery.enabled" = false;
        "browser.download.panel.shown" = true;
        "browser.newtabpage.enabled" = false;
        "browser.search.region" = "FI";
        "browser.search.suggest.enabled" = false;
        "browser.startup.homepage" = "about:blank";
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"customizableui-special-spring1\",\"urlbar-container\",\"customizableui-special-spring4\",\"developer-button\",\"add-ons-button\",\"downloads-button\",\"library-button\",\"sidebar-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"toolbar-menubar\",\"TabsToolbar\",\"PersonalToolbar\"],\"currentVersion\":16,\"newElementCount\":4}";
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.urlbar.placeholderName.private" = "DuckDuckGo";
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.topsites" = false;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "media.autoplay.default" = 5;
        "permissions.default.geo" = 2;
        "pref.privacy.disable_button.cookie_exceptions" = false;
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "signon.rememberSignons" = false;
        "signon.usage.hasEntry" = false;
      };
    };
  };
  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    extraConfig = "bindsym --release Print exec --no-startup-id ~/.bin/screenshot.sh";
    config = let
      mod = "Mod4";
      terminal = "xfce4-terminal";
      launcher = "${pkgs.rofi}/bin/rofi -show run";
      passwordManager = "${pkgs.keepassxc}/bin/keepassxc";
      prefixWithMod = mapAttrs' (name: value: { name = "${mod}+${name}"; value = value; });
      workspaceNames = [
        "0: misc" "1: chat" "2: web" "3" "4: code" "5: music" "6" "7" "8" "9: games"
      ];
      workspaces = listToAttrs (imap0 (index: name: { name = toString index; value = name; }) workspaceNames);
    in {
      startup = [
        {
          command = "setxkbmap us -variant altgr-intl";
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
      fonts = [ "JetBrains Mono 10" ];
      gaps = {
        inner = 10;
        outer = 5;
        smartGaps = true;
      };
      window = {
        hideEdgeBorders = "both";
        titlebar = false;
        border = 0;
      };
      modes = {};
      bars = [];
      keybindings = prefixWithMod {
        Return = "exec ${terminal}";
        q = "kill";
        w = "layout tabbed";
        e = "layout toggle split";
        r = "reload";
        "Shift+r" = "restart";

        t = "gaps inner current plus 5";
        "Shift+t" = "gaps inner current minus 5";
        z = "gaps outer current plus 5";
        "Shift+z" = "gaps outer current minus 5";

        "Shift+y" = "resize shrink width 10px or 10ppt";
        "Shift+u" = "resize shrink height 10px or 10ppt";
        "Shift+i" = "resize grow height 10px or 10ppt";
        "Shift+o" = "resize grow width 10px or 10ppt";

        a = "focus parent";
        "Shift+a" = "focus child";

        s = "layout stacking";
        "Shift+s" = "focus mode_toggle";

        d = "exec ${launcher}";

        f = "fullscreen toggle";
        "Shift+f" = "floating toggle";

        g = "smart_gaps on";
        "Shift+g" = "smart_gaps off";

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

