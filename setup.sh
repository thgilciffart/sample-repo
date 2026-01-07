#!/bin/sh
# Install yay package maanger on all systems
sudo pacman -S yay

# Install universal packages
sudo pacman -S --needed - <./devices/universal-packages.txt

# Syncthing configuration
# Load up default syncthing configuration

syncthing -no-browser -no-restart >/dev/null 2>&1 </dev/null &
sleep 10
pkill syncthing
sed -i 's/127.0.0.1/0.0.0.0/' $HOME/.local/state/syncthing/config.xml
sudo ufw allow syncthing
sudo ufw allow syncthing-gui

# Tailscale set up
sudo systemctl enable tailscaled
sudo systemctl start tailscaled
sudo tailscale set --operator=$USER

# Allow ssh through the firewall
sudo ufw allow ssh

# Fish set up
# Set fish as the default shell
command -v fish | sudo tee -a /etc/shells
chsh -s "$(command -v fish)"
# Installing fish plugins
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fish -c "fisher install jorgebucaran/nvm.fish"
fish -c "fisher install IlanCosman/tide@v6"
fish -c "fisher install PatrickF1/fzf.fish"
fish -c "nvm install latest"

# Add .config to system
cp -r ./devices/.configa $HOME
