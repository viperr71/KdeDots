#!/bin/bash
myvar="$(xrandr -q)"
if [[ $myvar == *"	eDP1 connected"* ]]
then
  xrandr --output HDMI1 --auto --primary;
  xrandr --output eDP1 --auto --right-of HDMI1;
else
  xrandr --output HDMI1 --auto;
fi