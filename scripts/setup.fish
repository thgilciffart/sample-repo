#!/usr/bin/env fish

chsh -s /usr/bin/fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher install jorgebucaran/nvm.fish
fisher install IlanCosman/tide@v6
fisher install PatrickF1/fzf.fish

nvm install latest
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.cargo/bin
mkdir -p $HOME/.config/scripts
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.config/scripts
