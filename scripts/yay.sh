#!/bin/sh

sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git /tmp/yay-bin
cd /tmp/yay-bin
makepkg -si
yay -Y --gendb
yay -Syu --devel
yay -Y --devel --save
