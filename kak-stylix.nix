{ pkgs, config, lib, ... }:

let
  themeFile = config.lib.stylix.colors {
    templateRepo = pkgs.fetchFromGitHub {
      owner = "tinted-theming";
      repo = "base16-kakoune";
      rev = "5b812fdb79cc9f2507332ae840cefe0a61304ac4";
      sha256 = "sha256-2sE2HKVH/F0dquGSmWmJuCFnFxjrCqm8CQbse3rVO5w=";
    };
  };
in
{
  options.stylix.targets.kakoune.enable =
    config.lib.stylix.mkEnableTarget "Kakoune" true;

  config = lib.mkIf config.stylix.targets.kakoune.enable {
    programs.kakoune = {
      extraConfig = builtins.readFile themeFile;
    };
  };
}

