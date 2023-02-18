{ config, pkgs, config-dir, ... }:
let
  configFile = name: {
    name = ".logseq/${name}";
    value.source = config.lib.file.mkOutOfStoreSymlink "${config-dir}/logseq/${name}";
  };
  configFiles = names: builtins.listToAttrs (map configFile names);
in
{
  home.packages = [ pkgs.logseq ];
  # TODO: plugin configs? preferences?
  # possibly nixify plugins, idk
  home.file = configFiles [ "config/config.edn" "config/plugins.edn" ];
}
