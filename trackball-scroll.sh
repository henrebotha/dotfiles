#! /usr/bin/env bash
# We export the trackball ID to make it easier to e.g. tinker with settings
# later in the shell
export TRACKBALL_ID=$(xinput list | rg 'Logitech USB Trackball' | rg -o 'id=(\d+)' | cut -d = -f 2)
xinput set-prop $TRACKBALL_ID "libinput Scroll Method Enabled" 0, 0, 1
xinput set-prop $TRACKBALL_ID "libinput Button Scrolling Button" 8
