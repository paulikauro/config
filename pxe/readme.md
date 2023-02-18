# PXE
Some config stuff for PXE.
- Network is assumed to have a DHCP server already
- dnsmasq augments existing DHCP with PXE stuff
- Some HTTP server can be used for file transfers, if needed. I'm using darkhttpd because it's easy to use (`darkhttpd .` serves the current directory)

# TODO
- [ ] separate home and system flakes? and organize things better
- [ ] caps/esc switch config not working
- [ ] try out qtile?
- [ ] fix todo stuffs and deprecations
- [/] vscode setup
    - [ ] customize vspacecode/whichkey
        - edamagit integration..? or why is it not there, it should be
        - other extension pack extensions (fuzzy search, file browser)
- [ ] better intellij idea setup
- [ ] direnv?
- [ ] starship..?
- [ ] fix screensaver
- [ ] tweak dunst and rofi
- [ ] screenshot key doesn't work, shell exits slowly after
- [ ] storage optimization? (also direnv keep-outputs/derivations?)
