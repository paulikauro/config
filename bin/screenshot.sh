#!/bin/sh
cd $XDG_PICTURES_DIR
scrot -s -e 'cat $f | xclip -sel clip -t image/png'

