#!/bin/sh
# Install yay package maanger on all systems
sudo pacman -S yay

# Install universal packages
yay -S -needed - <./devices/universal-packages.txt
