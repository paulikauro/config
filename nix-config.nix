{ pkgs, self, nixpkgs, nur, nil, emacs-overlay, ... }: {
  nix = {
    registry.nixpkgs.flake = nixpkgs;
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
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
}

