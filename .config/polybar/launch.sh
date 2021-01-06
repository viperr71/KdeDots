#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=HDMI1 polybar --reload xmonad &
    MONITOR=eDP1 polybar --reload xmonad2 &
  done
else
  polybar --reload xmonad &
  polybar --reload xmonad2 &
fi

echo "Bars launched..."
