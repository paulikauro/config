{
  description = "Configuration";
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, home-manager, nur, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.thonkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          ./thonkpad.nix
          ({ pkgs, ... }: {
            nix = {
              registry.nixpkgs.flake = nixpkgs;
              package = pkgs.nixUnstable;
              extraOptions = "experimental-features = nix-command flakes";
            };
            system.configurationRevision = self.rev or "dirty-git-tree";
            nixpkgs.overlays = [ nur.overlay ];
            nixpkgs.config.allowUnfree = true;
          })
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.testuser = { pkgs, ... }: {
                imports = [
                  ./desktop-environment.nix
                ];
                home.packages = with pkgs; [
                  jq
                  nix-index
                  gnome3.gnome-system-monitor
                  vim emacs
                  multimc
                  cryptsetup
                  openjdk
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
                ];
              };
            };
          }
        ];
      };
    };
}

