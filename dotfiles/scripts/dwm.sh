#!/bin/sh

cd $HOME/.config/dwm
sudo make clean install
sudo chown -R $USER:$USER .
