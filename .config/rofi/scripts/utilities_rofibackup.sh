#!/bin/bash

BORDER="#dddddd"
SEPARATOR="#1d1f21"
FOREGROUND="#dddddd"
BACKGROUND="#1d1f21"
BACKGROUND_ALT="#1d1f21"
HIGHLIGHT_BACKGROUND="#8abdb6"
HIGHLIGHT_FOREGROUND="#dddddd"
YELLOW="#fdd835"
ORANGE="#89400c"

SDIR="$HOME/.config/rofi/scripts"

# Launch Rofi
MENU="$(rofi -no-lazy-grab -sep "|" -dmenu -i -p 'Search :' \
-hide-scrollbar true \
-bw 0 \
-lines 5 \
-line-padding 5 \
-padding 15 \
-width 15 \
-xoffset -430 -yoffset 39 \
-location 3 \
-columns 1 \
-show-icons -icon-theme "Tela black dark" \
-font "DejaVuSans (TTF) 9" \
-color-enabled true \
-color-window "$BACKGROUND,$BORDER,$SEPARATOR" \
-color-normal "$BACKGROUND_ALT,$FOREGROUND,$BACKGROUND_ALT,$HIGHLIGHT_BACKGROUND,$HIGHLIGHT_FOREGROUND" \
-color-active "$BACKGROUND,$ORANGE,$BACKGROUND_ALT,$HIGHLIGHT_BACKGROUND,$HIGHLIGHT_FOREGROUND" \
-color-urgent "$BACKGROUND,$YELLOW,$BACKGROUND_ALT,$HIGHLIGHT_BACKGROUND,$HIGHLIGHT_FOREGROUND" \
<<< " Gparted| Grub-Customizer| Pamac| Spectacle| System-Settings")"
            case "$MENU" in
				## Commands
				*System-Settings) $SDIR/utilities.sh -System-Settings ;;
				*Pamac) $SDIR/utilities.sh -Pamac ;;
				*Gparted) $SDIR/utilities.sh -Gparted ;;
				*Grub-Customizer) $SDIR/utilities.sh -Grub-Customizer ;;
                *Spectacle) $SDIR/utilities.sh -Spectacle			
            esac
