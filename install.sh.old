#!/bin/sh
sudo pacman -S yay

yay -S

cp -r .config $HOME
cp -r ./configurations/texmf $HOME
texhash $HOME/texmf

# Applications
sudo npm install -g @google/gemini-cli

mkdir $HOME/Documents
mkdir $HOME/Screenshots
mkdir $HOME/Downloads

./scripts/browser.sh
./scripts/default.sh
./scripts/dwm.sh
./scripts/firewall.sh
./scripts/fonts.sh
./scripts/librepods.sh
./scripts/mprisence.sh
./scripts/setup.fish
./scripts/syncthing.sh
./scripts/theme.sh
./scripts/yay.sh
./scripts/zathura.sh
