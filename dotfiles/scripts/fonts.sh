#!/bin/sh

shopt -s globstar nullglob
rm -rf /tmp/fonts
sudo mkdir -p /usr/local/share/fonts/Apple
sudo mkdir -p /usr/local/share/fonts/iA-Writer
git clone https://github.com/thgilciffart/SF-Fonts.git /tmp/fonts/Apple-Fonts
git clone https://github.com/iaolo/iA-Fonts.git /tmp/fonts/iA-Writer
sudo cp /tmp/fonts/Apple-Fonts/AppleColorEmoji.ttf /usr/local/share/fonts/Apple 2>/dev/null
sudo cp /tmp/fonts/Apple-Fonts/**/*.otf /usr/local/share/fonts/Apple/ 2>/dev/null
sudo cp /tmp/fonts/iA-Writer/**/*.ttf /usr/local/share/fonts/iA-Writer/ 2>/dev/null
fc-cache -f -v 
