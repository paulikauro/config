{
  # /persist: persistent and backed up
  # /local: persistent but not backed up
  nixosModule = { theUsername, notrootDisk, ... }:
  {
    services.syncthing = {
      enable = true;
      user = theUsername;
      dataDir = "/persist";
      # does not need to be mounted
      configDir = "/local/myhome/.config/syncthing";
    };
    environment.persistence = {
      "/persist" = {
        hideMounts = true;
        directories = [
          "/etc/NetworkManager/system-connections"
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
          "/etc/secureboot"
          "/etc/cert"
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
        directories = [ "stash" ".config/emacs" ".config/ardour7" ];
      };
      "/local/myhome" = {
        allowOther = true;
        directories = [
          ".cabal"
          ".config/discord"
          ".config/kopia"
          ".config/pulse"
          ".ssh"
          ".local/share/PrismLauncher"
          ".local/share/direnv"
          ".mozilla/firefox"
        ];
      };
    };
  };
}
