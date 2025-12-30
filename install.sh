#!/bin/sh
# Install yay package maanger on all systems
sudo pacman -S yay

# Install universal packages
sudo pacman -S --needed - <./devices/universal-packages.txt

# Syncthing configuration
# Load up default syncthing configuration

syncthing -no-browser -no-restart >/dev/null 2>&1 </dev/null &
sleep 10
pkill syncthing
sed -i 's/127.0.0.1/0.0.0.0/' $HOME/.local/state/syncthing/config.xml
sudo ufw allow syncthing
sudo ufw allow syncthing-gui
