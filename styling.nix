{ base16-schemes, pkgs, ... }:
{
  stylix = {
    image = pkgs.fetchurl {
      url = "https://github.com/NixOS/nixos-artwork/raw/master/wallpapers/nix-wallpaper-gear.png";
      sha256 = "1gs4fl1q2aljnfdlgxn8wlhir637cvx54bnlnd9jk23zixpzmi6s";
    };
    polarity = "dark";
    base16Scheme = "${base16-schemes}/gruvbox-material-dark-medium.yaml";
    fonts.monospace = {
      name = "JetBrainsMono";
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
    };
  };
}

