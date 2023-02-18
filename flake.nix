{
  description = "Configuration";
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    arkenfox-nixos.url = "github:dwarfmaster/arkenfox-nixos";
  };
  outputs = { self, home-manager, nur, nixpkgs, nixos-hardware, arkenfox-nixos }@args:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.thonkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # specialArgs = args;
        modules = [
          home-manager.nixosModules.home-manager
          # NOTE: the thinkpad-e14-amd module, among other things,
          # - sets the kernel parameter iommu=soft (which is unnecessary for me)
          # - enables the fstrim service (which might be bad for disk encryption?)
          nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
          ./thonkpad.nix
          ({ pkgs, ... }: {
            nix = {
              registry.nixpkgs.flake = nixpkgs;
              package = pkgs.nixUnstable;
              # TODO protect nix-shell against GC? see nix-direnv readme
              extraOptions = "experimental-features = nix-command flakes";
              settings.extra-sandbox-paths = [ "/bin/sh" ];
            };
            system.configurationRevision = self.rev or "dirty-git-tree";
            nixpkgs = {
              overlays = [
                nur.overlay
                #(import ./discord-fix.nix)
              ];
              config.allowUnfree = true;
            };
          })
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                config-dir = "/home/testuser/config";
              };
              users.testuser = { pkgs, ... }: {
                imports = [
                  ./desktop-environment.nix
                  arkenfox-nixos.hmModules.arkenfox
                ];
                # TODO: cleanup
                home.stateVersion = "22.11";
                home.homeDirectory = "/home/testuser";
                # home.username = "testuser"; # not needed?
                home.packages = with pkgs; [
                  # qt5Full
                  openssl
                  openssl.dev
                  cmake
                  libglvnd
                  glxinfo
                  jq
                  nix-index
                  # gnome3.gnome-system-monitor
                  emacs
                  # minecraft
                  prismlauncher
                  cryptsetup
                  # openjdk
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
                  sbctl
                ];
              };
            };
          }
        ];
      };
    };
}

