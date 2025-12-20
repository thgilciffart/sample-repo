#!/bin/sh
yay -Syu

yay -S --needed --noconfirm - <packages/development.txt
yay -S --needed --noconfirm - <packages/system.txt
yay -S --needed --noconfirm - <packages/wm.txt
yay -S --needed --noconfirm - <packages/productivity.txt
yay -S --needed --noconfirm - <packages/entertainment.txt
yay -S --needed --noconfirm - <packages/misc.txt

cp -r .config $HOME
cp -r ./configurations/texmf $HOME
texhash $HOME/texmf

./scripts/dwm.sh
