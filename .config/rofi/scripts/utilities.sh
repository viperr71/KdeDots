#!/bin/bash

PDIR="$HOME/.config/rofi"
LAUNCH="polybar-msg cmd restart"
 
if  [[ $1 = "-System-Settings" ]]; then
systemsettings5
# Restarting polybar
$LAUNCH &

elif  [[ $1 = "-Pamac" ]]; then
pamac-manager
# Restarting polybar
$LAUNCH &

elif  [[ $1 = "-Gparted" ]]; then
gparted
# Restarting polybar
$LAUNCH &

elif  [[ $1 = "-Sublime" ]]; then
subl
# Restarting polybar
$LAUNCH &

elif  [[ $1 = "-Spectacle" ]]; then
spectacle
# Restarting polybar
$LAUNCH &

else
echo "Available options:
-System-Settings -Pamac -Gparted -Nitrogen -Spectacle"
fi
