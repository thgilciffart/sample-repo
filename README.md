These are my personal dotfiles. The configurations depends on what system I'm running them on. All the systems are running CachyOS, and thus system packages are installed through pacman/yay. 
# Desktop 
- i5 6400
- 2x8gb DDR4 JEDEC
- 1050 Ti
# Laptop
Microsoft Surface Laptop 3
- i5 1035G7
- 8GB DDR4
# Server
HP Elitedesk 800 G3 Mini
- i5 6500T
- 1x16gb DDR4 JEDEC
# Setting up
## Prerequisites
- A device running Linux (recommended to be Arch based)
- git
- an internet connection
## General info
- helium browser
- mpd
- fish shell
- neovim/zed
- dwm & dwmbar
- rofi
- alacritty
## Installation
To install simply run
```
git clone https://github.com/thgilciffart/dotfiles.git 
cd dotfiles
./setup.sh
```

See other info: 

[Desktop / Laptop setup](devices/computer/README.md)

[Server setup](devices/server/README.md)
