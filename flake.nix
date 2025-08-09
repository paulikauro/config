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
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nil.url = "github:oxalica/nil";
    stylix.url = "github:danth/stylix";
    base16-schemes = {
        url = "github:tinted-theming/base16-schemes";
        flake = false;
    };
    arkenfox-nixos.url = "github:dwarfmaster/arkenfox-nixos";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
  outputs = { nixpkgs, nixos-hardware, ... }@inputs:
    let
      mkSystem = { notrootDisk, modules }: nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            konf = {
              inherit notrootDisk;
              theUsername = "pauli";
              config-dir = "/etc/nixos";
            };
          };
          inherit modules;
      };
    in
    {
      nixosConfigurations = {
        tritonus = mkSystem {
          notrootDisk = "/dev/disk/by-uuid/49633c2c-82ca-4fa9-82a1-1b7d68f50ca5";
          modules = [
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-gpu-amd
            # this enables fstrim, see thonkpad config
            nixos-hardware.nixosModules.common-pc-ssd
            ./tritonus.nix
          ];
        };
        thonkpad = mkSystem {
          notrootDisk = "/dev/disk/by-uuid/c0bbd265-adbd-4957-911d-bab29592f613";
          modules = [
            # NOTE: the thinkpad-e14-amd module, among other things,
            # - sets the kernel parameter iommu=soft (which is unnecessary for me)
            # - enables the fstrim service (which might be bad for disk encryption?)
            nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
            ./thonkpad.nix
          ];
      };
    };
  };
}

