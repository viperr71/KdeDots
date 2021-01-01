# Disable KWin and use xmonad as WM
export KDEWM=/usr/bin/xmonad

# Compositor (Animations, Shadows, Transparency)
# xcompmgr -C
# picom -b --config ~/.config/picom/picom.conf
# On some configurations, `compton -b` may cause a display freeze. Use `compton &` instead
# https://www.reddit.com/r/archlinux/comments/4ffsrt/compton_freezing_with_b/
# https://wiki.archlinux.org/index.php/compton

# Start picom
picom & --config ~/.config/picom/picom.conf

