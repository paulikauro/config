{ config, konf, lib, pkgs, ... }:
let
  inherit (konf) config-dir;
in {
  xdg.configFile."zed/settings.json".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${config-dir}/zed/settings.json");
  xdg.configFile."zed/keymap.json".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${config-dir}/zed/keymap.json");
  #home.file."${config.xdg.configHome}/Code/User/settings.json".source =
  #  lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${config-dir}/vscode/settings.json");
  #home.file."${config.xdg.configHome}/Code/User/keybindings.json".source =
  #  lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${config-dir}/vscode/keybindings.json");
  programs = {
    zed-editor = {
      enable = true;
      # extraPackages = [ ];
      # note: only use extraPackages from here
    };
  };
}

