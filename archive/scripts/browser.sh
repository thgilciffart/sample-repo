#!/bin/sh

sudo mkdir -p /etc/brave/policies/managed
cd $HOME/.config/BraveSoftware
sudo cp brave-configuration.json /etc/brave/policies/managed
git clone https://github.com/refact0r/re-start $HOME/.config/re-start
cd $HOME/.config/re-start
npm i
npm run build:chrome
