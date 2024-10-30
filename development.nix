{ pkgs, config, config-dir, ... }:
let
  editor = "vim";
in
{
  imports = [ ./vscode ];
  # TODO bind neovim path?
  home.packages = with pkgs; [
    lsof
    racket
    jdk11
    jetbrains.idea-ultimate
    podman-compose
    jujutsu
    ghostscript
    clojure
    clojure-lsp
    nil
    # haskell-language-server
    ghc
    maven
    zip
    unzip
    nodejs
    tree
    gdb
    graphviz
    # jetbrains.idea-ultimate
    # verilator
    # verilog
    # gtkwave
    nixpkgs-fmt
    pkg-config
    openssl
    sqlite
    coq
    purescript
    # BROKEN spago
    dhall
    # BROKEN dhall-lsp-server
    fzf
    # agda
    # emacs dependencies
    fd
    ripgrep
    # the default tree-sitter plugins are fine
    emacs29
    emacs-all-the-icons-fonts
  ] ++ (with nodePackages; [
    purescript-language-server
    purs-tidy
    vscode-langservers-extracted
    typescript-language-server
    typescript
    yarn
  ]);
  home.sessionPath = [ "$HOME/.config/emacs/bin" ];
  home.shellAliases = {
    upnix = "sudo nixos-rebuild switch -v --flake /etc/nixos";
    ednix = "( cd /etc/nixos && ${editor} )";
    e = editor;
  };
  home.file.".ideavimrc".source = config.lib.file.mkOutOfStoreSymlink "${config-dir}/.ideavimrc";
  services.emacs = {
    enable = false; # todo
    startWithUserSession = true;
  };
  programs = {
    fish = {
      enable = true;
    };
    git = {
      enable = true;
      userName = "Pauli Kauro";
      userEmail = "3965357+paulikauro@users.noreply.github.com";
      extraConfig = {
        core.editor = editor;
        pull.rebase = false;
      };
    };
    neovim = {
      enable = true;
      vimAlias = true;
      extraConfig = builtins.readFile ./nvim.vim;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    bash = {
      enable = true;
      historyControl = [ "ignoredups" "ignorespace" ];
    };
    kitty = {
      enable = true;
    };
  };
}
