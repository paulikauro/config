#!/bin/sh
cd ~/screenshots
scrot -s -f -e 'cat $f | xclip -sel clip -t image/png'

