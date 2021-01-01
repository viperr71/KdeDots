#!/bin/sh
if [ `pidof picom` ]; then
    # Comment the line below to disable notifications
    notify-send -t 400 'Disabled picom' --icon=video-display
    # Kill picom
    killall picom
else
    # Comment the line below to disable notifications
    notify-send -t 400 'Enabled picom' --icon=video-display
    # Start picom as a daemon
    picom -b
fi
exit