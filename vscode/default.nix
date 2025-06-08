{ config, config-dir, lib, pkgs, nix-vscode-extensions, ... }:
let
  vsc-package = pkgs.vscode;
  vsc-exts = nix-vscode-extensions.forVSCodeVersion (vsc-package.version);
in
{
  # gh issue: whickey.show
  # settings.jsonc: normal/visual non recursive
  # - space: vspacecode.space
  # - comma: vspacecode.space -> whichkey.triggerKey (args: m)
  # vim.easymotion, vim.useSystemClipboard
  # vscode.vim

  # dunno, have to force it
  ### IMPORTANT /etc/nixos/vscode path is hardcoded in settings.json
  home.file."${config.xdg.configHome}/Code/User/settings.json".source =
    lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${config-dir}/vscode/settings.json");
  home.file."${config.xdg.configHome}/Code/User/keybindings.json".source =
    lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${config-dir}/vscode/keybindings.json");
  home.file.".vscode/argv.json".source = ./argv.json;
  programs = {
    vscode = {
      enable = true;
      package = vsc-package;
      profiles.default.extensions = with vsc-exts.vscode-marketplace; [
        ms-vscode.cmake-tools
        twxs.cmake
        slevesque.shader
        mkhl.direnv
        maximedenes.vscoq
        vspacecode.vspacecode
        vspacecode.whichkey
        banacorn.agda-mode
        nwolverson.language-purescript
        nwolverson.ide-purescript
        betterthantomorrow.calva
        haskell.haskell
        justusadam.language-haskell
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        kahole.magit
        asvetliakov.vscode-neovim
        llvm-vs-code-extensions.vscode-clangd
        #vadimcn.vscode-lldb
        dhall.dhall-lang
        dhall.vscode-dhall-lsp-server
        ziglang.vscode-zig
        yellpika.latex-input
        # workaround for https://github.com/nix-community/nix-vscode-extensions/issues/76
        # (including both extensions from there for consistency)
        pkgs.vscode-extensions.github.copilot
        pkgs.vscode-extensions.github.copilot-chat
      ];
    };
  };
}

