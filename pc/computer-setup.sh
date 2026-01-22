#!/bin/bash


echo "Installing packages"
yay -S --needed $(<pkglist.txt)
