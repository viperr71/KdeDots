#!/bin/bash

declare options=("alacritty
bash
dunst
menu
picom
polybar
sysmenu
termite
util
xinit
xmonad
xresources
xsession
zsh
quit")

choice=$(echo -e "${options[@]}" | dmenu -p 'Edit config file: ')

case "$choice" in
	quit)
		echo "Program terminated." && exit 1
	;;
	alacritty)
		choice="$HOME/.config/alacritty/alacritty.yml"
	;;
	bash)
		choice="$HOME/.bashrc"
	;;
	dunst)
		choice="$HOME/.config/dunst/dunstrc"
	;;
	menu)
		choice="$HOME/.config/rofi/scripts/menu"	
	;;
	picom)
		choice="$HOME/.config/picom/picom.conf"
	;;
	polybar)
		choice="$HOME/.config/polybar/config"
	;;	
	sysmenu)
		choice="$HOME/.config/rofi/scripts/sysmenu"	
	;;
	termite)
		choice="$HOME/.config/termite/config"
	;;	
	util)
		choice="$HOME/.config/rofi/scripts/util.sh"	
	;;
	xinit)
		choice="$HOME/xinitrc"	
	;;
	xmonad)
		choice="$HOME/.xmonad/xmonad.hs"
	;;
	xresources)
		choice="$HOME/.Xresources"
	;;
	xsession)
		choice="$HOME/.xsessionrc"
	;;
	zsh)
		choice="$HOME/.zshrc"
	;;
	*)
		exit 1
	;;
esac
alacritty -e code "$choice"
