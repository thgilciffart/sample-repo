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
sed -i 's/OVERLEAF_LISTEN_IP=127.0.0.1/OVERLEAF_LISTEN_IP=0.0.0.0/' $HOME/overleaf/toolkit/config/overleaf.rc
sed -i 's/PROJECT_NAME=overleaf/PROJECT_NAME=Overleaf Extended/' $HOME/overleaf/toolkit/config/overleaf.rc
sed -i 's/OVERLEAF_PORT=80/OVERLEAF_PORT=4200/' $HOME/overleaf/toolkit/config/overleaf.rc
sed -i 's/SIBLING_CONTAINERS_ENABLED=true/SIBLING_CONTAINERS_ENABLED=false/' $HOME/overleaf/toolkit/config/overleaf.rc
sudo ufw allow 4200/tcp
cat >$HOME/overleaf/toolkit/config/docker-compose.override.yml <<'overleaf-extended'
---
services:
  sharelatex:
    image: sharelatex/sharelatex-base:ext-ce
overleaf-extended
$HOME/overleaf/toolkit/bin/up
# syncthing

# mpd server

#
# misc. services
