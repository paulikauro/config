#!/bin/sh
setxkbmap us -variant altgr-intl -option caps:ctrl_modifier
xcape -e 'Caps_Lock=Escape'
