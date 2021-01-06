#!/bin/bash

BORDER="#2b2b2b"
SEPARATOR="#2b2b2b"
FOREGROUND="#dddddd"
BACKGROUND="#151718"
BACKGROUND_ALT="#2b2b2b"
HIGHLIGHT_BACKGROUND="#5681b3"
HIGHLIGHT_FOREGROUND="#242c36"
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
-xoffset -145 -yoffset 35 \
-border-radius: "100px" \
-location 3 \
-columns 1 \
-show-icons -icon-theme "Tela black dark" \
-font "DejaVuSans (TTF) 9" \
-color-enabled true \
-color-window "$BACKGROUND,$BORDER,$SEPARATOR" \
-color-normal "$BACKGROUND_ALT,$FOREGROUND,$BACKGROUND_ALT,$HIGHLIGHT_BACKGROUND,$HIGHLIGHT_FOREGROUND" \
-color-active "$BACKGROUND,$ORANGE,$BACKGROUND_ALT,$HIGHLIGHT_BACKGROUND,$HIGHLIGHT_FOREGROUND" \
-color-urgent "$BACKGROUND,$YELLOW,$BACKGROUND_ALT,$HIGHLIGHT_BACKGROUND,$HIGHLIGHT_FOREGROUND" \
<<< " Spectacle| Sublime| Pamac| Gparted| System-Settings")"
            case "$MENU" in
				## Commands
				*System-Settings) $SDIR/utilities.sh -System-Settings ;;
				*Pamac) $SDIR/utilities.sh -Pamac ;;
				*Gparted) $SDIR/utilities.sh -Gparted ;;
				*Sublime) $SDIR/utilities.sh -Sublime ;;
                *Spectacle) $SDIR/utilities.sh -Spectacle			
            esac
