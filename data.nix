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
          ];
          files = [
            # idk, apparently this is generated before it is mounted
            # "/etc/machine-id"
          ];
        };
      };
      programs.fuse.userAllowOther = true;
    };
  homeModule = { theUsername, ... }:
    {
      home.persistence = {
        "/persist/myhome" = {
          allowOther = true;
          directories = [ "stash" ];
        };
      };
    };
}