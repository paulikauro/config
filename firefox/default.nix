{ config, pkgs, config-dir, ... }:
{
  programs.firefox = {
    # TODO: dark theme, vimperator/vimium/tridactyl/???, userChrome
    enable = true;
    package = pkgs.firefox-esr-128;
    policies = {
      # 3rdparty
      # AutoLaunchProtocolsFromOrigins
      CaptivePortal = false;
      # Cookies
      DisableAppUpdate = true;
      # DisabledCiphers
      # DisableFeedbackCommands
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableFirefoxStudies = true;
      DisableForgetButton = true;
      DisableFormHistory = true;
      DisableMasterPasswordCreation = true;
      DisablePasswordReveal = true;
      DisablePocket = true;
      DisablePrivateBrowsing = true;
      DisableSetDesktopBackground = true;

      # This should also prevent system add-ons from being installed in the first place
      DisableSystemAddonUpdate = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "default-off";
      # DNSOverHTTPS
      DontCheckDefaultBrowser = true;
      # EnableTrackingProtection is covered by arkenfox
      # EncryptedMediaExtensions can be covered by arkenfox
      # Extensions, ExtensionSettings, ExtensionUpdate
      FirefoxHome = {
        Search = false;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        # Locked = true;
      };
      # Handlers
      # HardwareAcceleration
      Homepage = {
        URL = "about:blank";
        Additional = [ ];
        StartPage = "none";
        # Locked = true;
      };
      InstallAddonsPermission = {
        Allow = [ ];
        Default = false;
      };
      # ManagedBookmarks
      NetworkPrediction = false;
      NewTabPage = false;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      PasswordManagerEnabled = false;
      PDFjs = {
        # same as not DisableBuiltinPDFViewer
        Enabled = true;
        EnablePermissions = false;
      };
      # TODO: reconsider? apparently these are easily fingerprintable
      Permissions =
        let
          NOPE = {
            Allow = [ ];
            Block = [ ];
            BlockNewRequests = true;
            Locked = true;
          };
        in
        {
          Camera = NOPE;
          #Microphone = NOPE;
          Location = NOPE;
          # Notifications = NOPE;
          Autoplay = {
            Allow = [ ];
            Block = [ ];
            Default = "block-audio-video";
            Locked = true;
          };
        };
      PictureInPicture = {
        # unsure if this is cool or not
        Enabled = false;
        Locked = false;
      };
      PopupBlocking = {
        Default = true;
        Locked = false;
      };
      # Preferences
      PromptForDownloadLocation = true;
      # Proxy
      # SanitizeOnShutdown is covered by arkenfox
      SearchBar = "unified";
      SearchEngines = {
        Add = [
          {
            Name = "Nix Options";
            URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
            Method = "GET";
            Alias = "no";
          }
          {
            Name = "Nix Packages";
            URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
            Method = "GET";
            Alias = "np";
          }
          {
            Name = "Pursuit";
            URLTemplate = "https://pursuit.purescript.org/search?q={searchTerms}";
            Method = "GET";
            Alias = "ps";
          }
          {
            Name = "Hoogle";
            URLTemplate = "https://hoogle.haskell.org/?hoogle={searchTerms}";
            Method = "GET";
            Alias = "hs";
          }
          {
            Name = "Home-manager Options";
            URLTemplate = "https://mipmip.github.io/home-manager-option-search/?query={searchTerms}";
            Method = "GET";
            Alias = "ho";
          }
        ];
        Default = "DuckDuckGo";
        PreventInstalls = true;
        Remove = [ "Google" "Amazon.com" "Bing" "eBay" "Wikipedia (en)" ];
      };
      SearchSuggestEnabled = false;
      ShowHomeButton = false;
      # SSLVersionMin
      StartDownloadsInTempDirectory = true;
      TranslateEnabled = false;
      UserMessaging = {
        WhatsNew = false;
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
      };
      # UseSystemPrintDialog
    };
    arkenfox = {
      enable = true;
      version = "128.0";
    };
    profiles.default = {
      id = 0;
      name = "Default";
      isDefault = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        multi-account-containers
      ];
      arkenfox = {
        enable = true;
        "0000".enable = true;
        "0100".enable = true;
        "0200".enable = true;
        "0300".enable = true;
        "0400" = {
          enable = true;
          "0403"."browser.safebrowsing.downloads.remote.enabled".value = true;
        };
        "0600".enable = true;
        "0700" = {
          enable = true;
        };
        "0800" = {
          enable = true;
          # no visited link coloring
          "0820"."layout.css.visited_links_enabled".enable = true;
        };
        "0900".enable = true;
        "1000".enable = true;
        "1200".enable = true;
        # do not require OCSP (breaks some sites I need to use?)
        "1200"."1212"."security.OCSP.require".enable = false;
        "1600".enable = true;
        "1700".enable = true;
        # 2000 EME
        "2400".enable = true;
        "2600".enable = true;
        "2700".enable = true;
        "2800" = {
          enable = true;
        };
        # disable RFP for now
        "4500".enable = false;
        "6000".enable = true;
        "9000".enable = true;
      };
      settings = {
        # disable annoying "It looks like you haven't started Firefox in a while" popup
        "browser.disableResetPrompt" = true;
        # TODO replace with clearOnShutdown after upgrading to firefox 103+
        # replaced
        # "network.cookie.lifetimePolicy" = 2;
        # disable "Add application for mailto" -bar
        "network.protocol-handler.external.mailto" = false;
        # disable websites from messing with keybindings (GitHub likes to grab Ctrl+K to itself, which I use to search)
        "permissions.default.shortcuts" = 2;
        # disable suggestions in urlbar
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.topsites" = false;
        # enable font bounding box text metrics
        "dom.textMetrics.fontBoundingBox.enabled" = true;
        # breakage
        "security.OCSP.require" = false;
        #   "browser.bookmarks.defaultLocation" = "unfiled";
        #   "browser.download.panel.shown" = true;
        # ugh
        #   "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"customizableui-special-spring1\",\"urlbar-container\",\"customizableui-special-spring4\",\"developer-button\",\"add-ons-button\",\"downloads-button\",\"library-button\",\"sidebar-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"toolbar-menubar\",\"TabsToolbar\",\"PersonalToolbar\"],\"currentVersion\":16,\"newElementCount\":4}";
        # why?
        #   "pref.privacy.disable_button.cookie_exceptions" = false;
      };
    };
  };
}
