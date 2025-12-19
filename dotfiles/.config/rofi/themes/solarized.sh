#!/bin/sh

fish -c "set -Ux BAT_THEME 'Solarized (light)' "
feh --bg-max $HOME/.config/wallpapers/solarized.png

cp $HOME/.config/dunst/solarized.dunstrc $HOME/.config/dunst/dunstrc
systemctl --user restart dunst
wal --theme solarized -l
