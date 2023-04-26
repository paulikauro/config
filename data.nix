{
  # /persist: persistent and backed up
  # /local: persistent but not backed up
  nixosModule = { theUsername, ... }:
  {
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
        what = "/dev/disk/by-uuid/c0bbd265-adbd-4957-911d-bab29592f613";
        where = "/home/${theUsername}/.steam";
        unitConfig.DefaultDependencies = "no";
        type = "btrfs";
        options = "noatime,subvol=dotsteam";
        requires = [ "home-manager-${theUsername}.service" ];
        after = [ "home-manager-${theUsername}.service" ];
        wantedBy = [ "graphical.target" ];
      }
      {
        what = "/dev/disk/by-uuid/c0bbd265-adbd-4957-911d-bab29592f613";
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
