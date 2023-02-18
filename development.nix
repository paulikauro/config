{ config, pkgs, ... }:
{
  # TODO bind neovim path?
  home.packages = with pkgs; [
    ghostscript
    clojure
    clojure-lsp
    haskell-language-server
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
    spago
    dhall
    dhall-lsp-server
    # agda
  ];
  # gh issue: whickey.show
  # settings.jsonc: normal/visual non recursive
  # - space: vspacecode.space
  # - comma: vspacecode.space -> whichkey.triggerKey (args: m)
  # vim.easymotion, vim.useSystemClipboard
  xdg.configFile."vscode.vim".text = ''
    nnoremap <space> <Cmd>call VSCodeNotify('vspacecode.space')<CR>
    vnoremap <space> <Cmd>call VSCodeNotify('vspacecode.space')<CR>
    nnoremap , <Cmd>call VSCodeNotify('vspacecode.space')<CR><Cmd>call VSCodeNotify('whichkey.triggerKey', 'm')<CR>
    vnoremap , <Cmd>call VSCodeNotify('vspacecode.space')<CR><Cmd>call VSCodeNotify('whichkey.triggerKey', 'm')<CR>
  '';
  programs = {
    git = {
      enable = true;
      userName = "Pauli Kauro";
      userEmail = "3965357+paulikauro@users.noreply.github.com";
      extraConfig = {
        core.editor = "vim";
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
    vscode = {
      enable = true;
      # package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        betterthantomorrow.calva
        haskell.haskell
        justusadam.language-haskell
        jnoortheen.nix-ide
        matklad.rust-analyzer
        kahole.magit
        asvetliakov.vscode-neovim
        llvm-vs-code-extensions.vscode-clangd
        vadimcn.vscode-lldb
        dhall.dhall-lang
        dhall.vscode-dhall-lsp-server
        tiehuis.zig
        # vspacecode.whichkey
        # vspacecode.vspacecode
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "cmake-tools";
          publisher = "ms-vscode";
          version = "1.12.16";
          sha256 = "058dxc6ka5amlr42cqxypzqr20yqyq3vdflh2vkham6myq71fivh";
        }
        {
          name = "cmake";
          publisher = "twxs";
          version = "0.0.17";
          sha256 = "11hzjd0gxkq37689rrr2aszxng5l9fwpgs9nnglq3zhfa1msyn08";
        }
        {
          name = "shader";
          publisher = "slevesque";
          version = "1.1.5";
          sha256 = "14yraymi96f6lpcrwk93llbiraq8gqzk7jzyw7xmndhcwhazpz9x";
        }
        {
          name = "direnv";
          publisher = "mkhl";
          version = "0.6.1";
          sha256 = "1d60hqww1innch277yd3va2snpsp19c7w4v0rxz2jvzvgykfmx77";
        }
        {
          name = "vscoq";
          publisher = "maximedenes";
          version = "0.3.6";
          sha256 = "1sailpizg7zvncggdma9dyxdnga8jya1a2vswwij1rzd9il04j3g";
        }
        {
          name = "vspacecode";
          publisher = "vspacecode";
          version = "0.10.9";
          sha256 = "01d43dcd5293nlp6vskdv85h0qr8xlq8j9vdzn0vjqr133c05anp";
        }
        {
          name = "whichkey";
          publisher = "vspacecode";
          version = "0.11.3";
          sha256 = "0zix87vl2rig8wn3f6f3n6zdi0c61za3lw7xgm28sjhwwb08wxiy";
        }
        {
          name = "agda-mode";
          publisher = "banacorn";
          version = "0.3.7";
          sha256 = "0hmldbyldr4h53g5ifrk5n5504yzhbq5hjh087id6jbjkp41gs9b";
        }
        {
          name = "language-purescript";
          publisher = "nwolverson";
          version = "0.2.8";
          sha256 = "1nhzvjwxld53mlaflf8idyjj18r1dzdys9ygy86095g7gc4b1qys";
        }
        {
          name = "ide-purescript";
          publisher = "nwolverson";
          version = "0.25.12";
          sha256 = "1f9064w18wwp3iy8ciajad8vlshnzyhnqy8h516k0j5bflz781mn";
        }
      ];
      userSettings = {
        "keyboard.dispatch" = "keyCode";
        "editor.minimap.enabled" = false;
        "editor.formatOnSave" = true;
        "editor.formatOnPaste" = true;
        # TODO this should probably be done by the extension
        "vscode-neovim.neovimExecutablePaths.linux" = "${pkgs.neovim}/bin/nvim";
        # TODO how to not hardcode
        "vscode-neovim.neovimInitVimPaths.linux" = "~/.config/vscode.vim";
        "agdaMode.connection.agdaPath" = "${pkgs.agda}/bin/agda";
        "calva.prettyPrintingOptions" = {
          "enabled" = true;
          "width" = 120;
          "maxLength" = 50;
          "printEngine" = "pprint";
        };
        "clangd.onConfigChanged" = "restart";
        "haskell.manageHLS" = "PATH";
        "lldb.suppressUpdateNotifications" = true;
      };
      keybindings = [
        {
          key = "ctrl+j";
          command = "selectNextSuggestion";
          when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
        }
        {
          key = "ctrl+j";
          command = "list.focusDown";
          when = "listFocus && !inputFocus";
        }
        {
          key = "ctrl+j";
          command = "focusNextCodeAction";
          when = "CodeActionMenuVisible";
        }
        {
          key = "ctrl+k";
          command = "selectPrevSuggestion";
          when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
        }
        {
          key = "ctrl+k";
          command = "list.focusUp";
          when = "listFocus && !inputFocus";
        }
        {
          key = "ctrl+k";
          command = "focusPreviousCodeAction";
          when = "CodeActionMenuVisible";
        }
        {
          key = "ctrl+l";
          command = "workbench.action.nextEditorInGroup";
        }
        {
          key = "ctrl+h";
          command = "workbench.action.previousEditorInGroup";
        }
        {
          key = "ctrl+t";
          command = "workbench.action.focusActiveEditorGroup";
          when = "terminalFocus";
        }
        {
          key = "ctrl+t";
          command = "workbench.action.terminal.focusNext";
          when = "!terminalFocus";
        }
        {
          key = "escape";
          command = "vscode-neovim.escape";
          when = "editorTextFocus && neovim.init";
        }
        {
          key = "alt+enter";
          command = "-calva.evaluateCurrentTopLevelForm";
        }
        {
          key = "alt+enter";
          command = "problems.action.showQuickFixes";
          when = "problemFocus";
        }
      ];
    };
  };
}
