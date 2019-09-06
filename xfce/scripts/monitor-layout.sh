#!/bin/sh

# Adapted from https://fedidat.com/420-xfce-display-auto/

logfile='/home/hbotha/xfce-monitor-log.txt'

date >> $logfile
sleep 1 # Give the system time to setup the connection

dmode="$(cat /sys/devices/platform/evdi.0/drm/card1/card1-DVI-I-1/status)"
export DISPLAY=:0
export XAUTHORITY=/home/hbotha/.Xauthority

if [ "${dmode}" = disconnected ]; then
    echo disconnected >> $logfile
elif [ "${dmode}" = connected ]; then
    # We should see our desired monitor's resolution in the output
    if xrandr -q | grep -q "1920"; then
        /usr/bin/xrandr --output DVI-I-1-1 --mode 1920x1080 --pos 0x0 --rotate normal --output eDP-1 --primary --mode 1920x1080 --pos 0x1080 --rotate normal --output HDMI-2 --off --output HDMI-1 --off --output DP-2 --off --output DP-1 --off 2>&1 | tee -a $logfile
        echo "success" >> $logfile
    else
        echo "no resolution, bad setup" >> $logfile
    fi
else
    echo "unknown event" >> $logfile
fi
