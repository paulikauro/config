{ config, lib, pkgs, nix-vscode-extensions, ...}:
let
  vsc-package = pkgs.vscode;
  vsc-exts = nix-vscode-extensions.forVSCodeVersion (vsc-package.version);
in {
  # gh issue: whickey.show
  # settings.jsonc: normal/visual non recursive
  # - space: vspacecode.space
  # - comma: vspacecode.space -> whichkey.triggerKey (args: m)
  # vim.easymotion, vim.useSystemClipboard
  #xdg.configFile."vscode.vim".source = ./vscode.vim;
  programs = {
    vscode = {
      enable = true;
      package = vsc-package;
      extensions = with vsc-exts.vscode-marketplace; [
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
        vadimcn.vscode-lldb
        dhall.dhall-lang
        dhall.vscode-dhall-lsp-server
        tiehuis.zig
      ];
      userSettings = {
        "telemetry.telemetryLevel" = "off";
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

