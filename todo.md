todo, or something
- config organization
    - separate things into smaller... units? so that system upgrade is easy and doesn't require upgrading everything
    - separate home and system configs or flakes?
- try out qtile? or something else
- fix TODOs
- intellij idea setup:
    - java path has to be selected again when it updates
    - some caching issue (everything is red after restarting it (or rebooting))
- tweak dunst and rofi
- screenshot doesn't work properly
    - does shell exit slowly afterwards still?
    - it closes certain things I want to screenshot when I press it
- storage optimizations? (also direnv keep-outputs/derivations?)
- persist VLC preferences
- out-of-store symlinks might be useful for frequently modified (or mutable) config files:
home.file.".whatever_rc".source = config.lib.file.mkOutOfStoreSymlink ./whatever;
- firefox
    - vimperator/vimium
- replacing open/save file dialogs
- nix-colors? and other theming stuff
    - I'm using Stylix for now
- clipboard things?
- password management, SSH agent
- tlp for power? or something else
- fingerprint scanner (experimental driver)
- usbguard

- better diffing of configs
    - produce derivation: `nix path-info --derivation .#nixosConfigurations.<hostname>.config.system.build.toplevel`
    - can do: `nix run nixpkgs#nix-diff A B` to diff, but it's a bit noisy
- secureboot and disk encryption
    - toggleable lanzaboote/systemd-boot konf to help with installation
    - tpm2 with pin for both? extra USB thing for thonkpad still?

- try replacing bindfs with normal bind mounts for impermanence (home-manager module only; other one already does this)
    - this could fix the steam issue that is currently fixed with the btrfs subvolumes

- backups
    - BackBlaze B2 has Object Lock
        - and make sure permissions make sense... so that malware/haxor cannot delete backups from laptop

