{
  # TODO is there a need for only synced or only backed up? (persistent of course)
  # /persist: persistent, backed up, synced
  # /local: persistent, not backed up, not synced
  nixosModule = { theUsername, notrootDisk, ... }:
  {
    services.syncthing = {
      enable = true;
      user = theUsername;
      group = "users";
      # data dir is redundant, but whatever
      dataDir = "/homeless-shelter";
      # does not need to be mounted
      configDir = "/local/myhome/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        devices = {
          thonkpad.id = "O2T4MYU-HLHROBL-7AMG7ND-GCIG36U-UEEXTJL-E5XQ45H-S3XXDQW-ZHVURQL";
          tritonus.id = "QPXZZ5I-5SWA5NK-5SYUCGW-UZGZM73-O4WUYPH-MDRDYKB-HFFDHIT-FM5LCA2";
          hupelin.id = "SVPSX7W-WFT5VD7-L76BPGK-AHQBQOZ-C3KIR6J-KHBG3LR-5G2H5LS-INKJMAY";
          pikseli.id = "SQKNZBU-IKIUTW7-MLHVTVC-N34REAF-M6ITSW7-NPKKBIZ-VUIJ53Y-GGIQAQ2";
        };
        folders = {
          "/persist" = {
            id = "persist";
            label = "persist";
            devices = [ "thonkpad" "tritonus" ];
            # sync permissions too!
            ignorePerms = false;
          };
          # note that hupelin is not persisted!
          "/home/${theUsername}/hupelin" = {
            id = "xdqzd-1k8sj";
            label = "hupelin";
            devices = [ "pikseli" "hupelin" "thonkpad" "tritonus" ];
            # dont rly care
            ignorePerms = true;
          };
        };
      };
      # it's the default, but in case it ever changes
      guiAddress = "127.0.0.1:8384";
      openDefaultPorts = true;
    };
    environment.persistence = {
      "/persist" = {
        hideMounts = true;
        directories = [
          {
            directory = "/etc/nixos";
            user = theUsername;
            group = "users";
            mode = "0755";
          }
        ];
      };
      "/local" = {
        hideMounts = true;
        directories = [
          "/etc/NetworkManager/system-connections"
          "/etc/secureboot"
          "/etc/cert"
          "/var/lib/nixos"
          "/var/lib/systemd"
          "/var/log/journal"
        ];
        files = [
          "/etc/machine-id"
        ];
      };
    };
    programs.fuse.userAllowOther = true;

    # these two are mounted after home-manager so that ~/.local isn't owned by root...
    systemd.mounts = [
      {
        what = notrootDisk;
        where = "/home/${theUsername}/.steam";
        unitConfig.DefaultDependencies = "no";
        type = "btrfs";
        options = "noatime,subvol=dotsteam";
        requires = [ "home-manager-${theUsername}.service" ];
        after = [ "home-manager-${theUsername}.service" ];
        wantedBy = [ "graphical.target" ];
      }
      {
        what = notrootDisk;
        where = "/home/${theUsername}/.local/share/Steam";
        unitConfig.DefaultDependencies = "no";
        type = "btrfs";
        options = "noatime,subvol=localsteam";
        requires = [ "home-manager-${theUsername}.service" ];
        after = [ "home-manager-${theUsername}.service" ];
        wantedBy = [ "graphical.target" ];
      }
    ];
  };
  hmModule = { theUsername, ... }:
  {
    home.persistence = {
      "/persist/myhome" = {
        allowOther = true;
        directories = [
          "stash"
          ".config/emacs"
          ".config/ardour8"
          ".local/share/PrismLauncher"
        ];
      };
      "/local/myhome" = {
        allowOther = true;
        directories = [
          ".cabal"
          ".cache"
          ".config/discord"
          ".config/kopia"
          ".config/pulse"
          ".config/unity3d"
          ".config/JetBrains"
          ".ssh"
          ".java"
          ".local/share/direnv"
          ".local/share/containers"
          ".local/share/TelegramDesktop"
          ".local/share/emacs"
          ".local/share/bottles"
          ".local/share/JetBrains"
          ".mozilla/firefox"
          ".unison"
        ];
      };
    };
  };
}
