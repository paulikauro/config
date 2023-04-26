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
    # TODO remove when lanzaboote updates
    rust-overlay.url = "github:oxalica/rust-overlay";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    # 100% cpu
    #nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nil.url = "github:oxalica/nil";
    stylix.url = "github:danth/stylix";
    base16-schemes = {
        url = "github:tinted-theming/base16-schemes";
        flake = false;
    };
    arkenfox-nixos.url = "github:dwarfmaster/arkenfox-nixos";
  };
  outputs = { self, home-manager, nur, nixpkgs, nixos-hardware, impermanence, rust-overlay, lanzaboote, emacs-overlay, nil, stylix, base16-schemes, arkenfox-nixos }@args:
    let
      theUsername = "pauli";
      dataModules = import ./data.nix;
    in
    {
      nixosConfigurations.thonkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit theUsername; } // args;
        modules = [
          home-manager.nixosModules.home-manager
          impermanence.nixosModules.impermanence
          lanzaboote.nixosModules.lanzaboote
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
              settings = {
                experimental-features = [ "nix-command" "flakes" "repl-flake" ];
                keep-outputs = true;
                keep-derivations = true;
                substituters = [
                  "https://cache.nixos.org"
                  "https://nix-community.cachix.org"
                  # haskell.nix stuff is cached here
                  "https://cache.iog.io"
                ];
                trusted-public-keys = [
                  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                  # haskell.nix
                  "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
                ];
                extra-sandbox-paths = [ "/bin/sh" ];
              };
            };
            system.configurationRevision = self.rev or "dirty-git-tree";
            nixpkgs = {
              overlays = [
                nur.overlay
                nil.overlays.nil
                emacs-overlay.overlays.emacs
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
                  dataModules.hmModule
                  arkenfox-nixos.hmModules.arkenfox
                  (_: { stylix.targets.vscode.enable = false; })
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
              };
            };
          }
        ];
      };
    };
}

