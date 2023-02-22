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
    impermanence.url = "github:nix-community/impermanence";
    stylix.url = "github:danth/stylix";
    base16-schemes = {
        url = "github:tinted-theming/base16-schemes";
        flake = false;
    };
    arkenfox-nixos.url = "github:dwarfmaster/arkenfox-nixos";
  };
  outputs = { self, home-manager, nur, nixpkgs, nixos-hardware, impermanence, stylix, base16-schemes, arkenfox-nixos }@args:
    let
      theUsername = "testuser";
      dataModules = import ./data.nix;
    in
    {
      nixosConfigurations.thonkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit theUsername; } // args;
        modules = [
          home-manager.nixosModules.home-manager
          impermanence.nixosModules.impermanence
          dataModules.nixosModule
          # NOTE: the thinkpad-e14-amd module, among other things,
          # - sets the kernel parameter iommu=soft (which is unnecessary for me)
          # - enables the fstrim service (which might be bad for disk encryption?)
          nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
          ./thonkpad.nix
          stylix.nixosModules.stylix
          ./styling.nix
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
                config-dir = "/etc/nixos";
                inherit theUsername;
              } // args;
              users.${theUsername} = { pkgs, ... }: {
                imports = [
                  ./desktop-environment.nix
                  impermanence.nixosModules.home-manager.impermanence
                  dataModules.homeModule
                  arkenfox-nixos.hmModules.arkenfox
                  (_: { stylix.targets.vscode.enable = false; })
                  ./kak-stylix.nix
                ];
                # TODO: cleanup
                home.stateVersion = "23.05";
                home.homeDirectory = "/home/${theUsername}";
                # home.username = theUsername; # not needed?
                home.packages = with pkgs; [
                  openssl
                  openssl.dev
                  nvme-cli
                  kopia
                  cmake
                  libglvnd
                  glxinfo
                  jq
                  nix-index
                  emacs
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

