#!/bin/sh

# Install server packages

yay -S --needed - <server-packages.txt

# Docker set up
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service

# Karakeep

# Copyparty

# nginx proxy manager

# overleaf
mkdir $HOME/overleaf
git clone https://github.com/yu-i-i/overleaf-cep $HOME/overleaf/extended
git clone https://github.com/overleaf/toolkit $HOME/overleaf/toolkit
(cd $HOME/overleaf/extended/server-ce && make)
$HOME/overleaf/toolkit/bin/init
cat >$HOME/overleaf/toolkit/config/docker-compose.override.yml <<'overleaf-extended'
---
services:
  sharelatex:
    image: sharelatex/sharelatex-base:ext-ce
overleaf-extended

# syncthing

# mpd server

#
# misc. services
