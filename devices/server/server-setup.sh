#!/bin/sh

# Install server packages

sudo pacman -S --needed - <server-packages.txt

# Docker set up
sudo groupadd docker
sudo usermod -aG docker $USER

# Karakeep

# Copyparty

# nginx proxy manager

# overleaf

# syncthing

# services
sudo systemctl enable --now ddclient.service
sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service
