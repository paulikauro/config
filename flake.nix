{
  description = "Configuration";
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs-wine94.url = "github:nixos/nixpkgs/f60836eb3a850de917985029feaea7338f6fcb8a";
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
    # HAX https://github.com/danth/stylix/issues/642
    base16.url = "github:SenchoPens/base16.nix?ref=refs/pull/19/head";
    stylix.url = "github:danth/stylix";
    stylix.inputs.base16.follows = "base16";
    base16-schemes = {
        url = "github:tinted-theming/base16-schemes";
        flake = false;
    };
    arkenfox-nixos.url = "github:dwarfmaster/arkenfox-nixos";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
  outputs = { self, home-manager, nur, nixpkgs, nixos-hardware, impermanence, rust-overlay, lanzaboote, emacs-overlay, nil, stylix, base16-schemes, arkenfox-nixos, /*nixpkgs-wine94,*/ nix-vscode-extensions, ... }@args:
    let
      theUsername = "pauli";
      dataModules = import ./data.nix;
    in
    {
      nixosConfigurations = {
        tritonus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = args // {
            inherit theUsername;
            notrootDisk = "/dev/disk/by-uuid/49633c2c-82ca-4fa9-82a1-1b7d68f50ca5";
          };
          modules = [
            home-manager.nixosModules.home-manager
            impermanence.nixosModules.impermanence
            lanzaboote.nixosModules.lanzaboote
            dataModules.nixosModule
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-gpu-amd
            # this enables fstrim, see thonkpad config
            nixos-hardware.nixosModules.common-pc-ssd
            ./tritonus.nix
            stylix.nixosModules.stylix
            ./styling.nix
            ./nix-config.nix
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = args // {
                  config-dir = "/etc/nixos";
                  inherit theUsername;
                  nix-vscode-extensions = nix-vscode-extensions.extensions.x86_64-linux;
                  #pkgs-wine94 = import nixpkgs-wine94 { system = "x86_64-linux"; }; # hax
                };
                users.${theUsername} = { pkgs, ... }: {
                  imports = [
                    ./desktop-environment.nix
                    impermanence.nixosModules.home-manager.impermanence
                    dataModules.hmModule
                    arkenfox-nixos.hmModules.arkenfox
                    #(_: { stylix.targets.vscode.enable = false; })
                  ];
                  # TODO: cleanup
                  home.stateVersion = "23.05";
                  home.homeDirectory = "/home/${theUsername}";
                  # home.username = theUsername; # not needed?
                };
              };
            }
          ];
        };
        thonkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = args // {
            inherit theUsername;
            notrootDisk = "/dev/disk/by-uuid/c0bbd265-adbd-4957-911d-bab29592f613";
          };
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
            ./nix-config.nix
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = args // {
                  config-dir = "/etc/nixos";
                  inherit theUsername;
                  nix-vscode-extensions = nix-vscode-extensions.extensions.x86_64-linux;
                  #pkgs-wine94 = import nixpkgs-wine94 { system = "x86_64-linux"; }; # hax
                };
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
                };
              };
            }
          ];
      };
    };
  };
}

