#!/bin/sh

# Set Zathura for PDFs
xdg-mime default org.pwmt.zathura.desktop application/pdf

# Set Brave for web browsers
xdg-mime default helium-browser.desktop x-scheme-handler/http
xdg-mime default helium-browser.desktop x-scheme-handler/https
xdg-mime default helium-browser.desktop text/html

# Set nvim for text files
xdg-mime default nvim.desktop text/plain
xdg-mime default nvim.desktop application/json
xdg-mime default nvim.desktop application/x-yaml
xdg-mime default nvim.desktop text/x-python
xdg-mime default nvim.desktop text/x-shellscript
xdg-mime default nvim.desktop application/xml
xdg-mime default nvim.desktop text/css
xdg-mime default nvim.desktop text/html
xdg-mime default nvim.desktop text/javascript
xdg-mime default nvim.desktop inode/x-empty

# Set MPV for videos
xdg-mime default mpv.desktop video/mp4
xdg-mime default mpv.desktop video/x-matroska
xdg-mime default mpv.desktop video/webm
xdg-mime default mpv.desktop video/avi
xdg-mime default mpv.desktop video/mpeg

# Set nomacs for images
xdg-mime default org.nomacs.ImageLounge.desktop image/jpeg
xdg-mime default org.nomacs.ImageLounge.desktop image/png
xdg-mime default org.nomacs.ImageLounge.desktop image/gif
xdg-mime default org.nomacs.ImageLounge.desktop image/webp
xdg-mime default org.nomacs.ImageLounge.desktop image/bmp
