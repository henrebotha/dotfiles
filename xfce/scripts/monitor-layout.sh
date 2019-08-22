#!/bin/sh

date >> log.txt #log the date for debug purposes
sleep 1 #give the system time to setup the connection

#CHANGE THE 'DP-1' IN THE FOLLOWING LINE
dmode="$(cat /sys/devices/platform/evdi.0/drm/card1/card1-DVI-I-1/status)"
export DISPLAY=:0
export XAUTHORITY=/home/hbotha/.Xauthority

if [ "${dmode}" = disconnected ]; then
    echo disconnected >> log.txt
elif [ "${dmode}" = connected ]; then
    if xrandr -q | grep -q "1920"; then #the resolution should appear
        #THIS IS THE XRANDR COMMAND, output piped to the log
        /usr/bin/xrandr --output DVI-I-1-1 --mode 1920x1080 --pos 0x0 --rotate normal --output eDP-1 --primary --mode 1920x1080 --pos 0x1080 --rotate normal --output HDMI-2 --off --output HDMI-1 --off --output DP-2 --off --output DP-1 --off 2>&1 | tee -a log.txt
        echo "success" >> log.txt
    else
        echo "no resolution, bad setup" >> log.txt
    fi
else
    echo "unknown event" >> log.txt
fi
