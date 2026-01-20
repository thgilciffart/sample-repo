#!/bin/sh
rm -rf /tmp/McMojave-circle /tmp/McMojave-cursors /tmp/Mojave-gtk-theme
git clone https://github.com/vinceliuice/McMojave-circle.git /tmp/McMojave-circle
git clone https://github.com/vinceliuice/McMojave-cursors.git /tmp/McMojave-cursors
git clone https://github.com/vinceliuice/Mojave-gtk-theme.git /tmp/Mojave-gtk-theme
cd /tmp/McMojave-circle
./install.sh -t default purple grey
cd /tmp/McMojave-cursors
./install.sh
cd /tmp/Mojave-gtk-theme
./install.sh -t default purple grey
