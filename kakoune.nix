{ config, pkgs, ... }:
let
  tomlFormat = pkgs.formats.toml { };
  # see https://github.com/kak-lsp/kak-lsp/blob/master/kak-lsp.toml for defaults
  kak-lsp-config = {
    snippet_support = true;
    verbosity = 2;
    server.timeout = 1800;
    language = {
      c_cpp = {
        filetypes = ["c" "cpp"];
        roots = ["compile_commands.json" ".clangd" ".git"];
        command = "clangd";
      };
      clojure = {
        # TODO edn?
        filetypes = ["clojure"];
        roots = ["project.clj" "deps.edn" ".lsp/config.edn" ".git"];
        command = "clojure-lsp";
      };
      nix = {
        filetypes = ["nix"];
        roots = ["flake.nix" "shell.nix" ".git"];
        command = "nil";
      };
    };
  };
in
{
  xdg.configFile."kak-lsp/kak-lsp.toml".source = tomlFormat.generate "kak-lsp.toml" kak-lsp-config;
    programs.kakoune = {
      enable = true;
      plugins = with pkgs.kakounePlugins; [
        kak-lsp
        parinfer-rust
      ];
      config = {
        tabStop = 4;
        showMatching = true;
        numberLines = {
          enable = true;
          highlightCursor = true;
        };
        showWhitespace = {
          enable = true;
        };
      };
      # TODO selectively enable lsp
      # TODO change selection colors in insert mode
      # TODO highlight matching with background color too
      # TODO expand tab
      extraConfig = ''
    eval %sh{kak-lsp --kakoune -s $kak_session}
    lsp-enable
    '';
    };
}

