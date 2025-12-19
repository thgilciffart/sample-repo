#!/bin/sh
cat <<'PENGUIN'
        .--.
       |o_o |
       |:_/ |
      //   \ \
     (|     | )
    /'\_   _/`\
    \___)=(___/
PENGUIN

echo "Welcome to the system installer!"
echo "User: $USER"
echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"

# Install yay

cat <<'yay-installer'
_____          _        _ _ _              __   __
|_   _|        | |      | | (_)             \ \ / /
 | | _ __  ___| |_ __ _| | |_ _ __   __ _   \ V /__ _ _   _
 | || '_ \/ __| __/ _` | | | | '_ \ / _` |   \ // _` | | | |
_| || | | \__ \ || (_| | | | | | | | (_| |   | | (_| | |_| |
\___/_| |_|___/\__\__,_|_|_|_|_| |_|\__, |   \_/\__,_|\__, |
                                     __/ |             __/ |
                                    |___/             |___/
yay-installer

./scripts/yay.sh

cat <<'package-installer'
_____          _        _ _ _                                _
|_   _|        | |      | | (_)                              | |
 | | _ __  ___| |_ __ _| | |_ _ __   __ _   _ __   __ _  ___| | ____ _  __ _  ___  ___
 | || '_ \/ __| __/ _` | | | | '_ \ / _` | | '_ \ / _` |/ __| |/ / _` |/ _` |/ _ \/ __|
_| || | | \__ \ || (_| | | | | | | | (_| | | |_) | (_| | (__|   < (_| | (_| |  __/\__ \
\___/_| |_|___/\__\__,_|_|_|_|_| |_|\__, | | .__/ \__,_|\___|_|\_\__,_|\__, |\___||___/
                                     __/ | | |                          __/ |
                                    |___/  |_|                         |___/
package-installer

yay -S --needed --noconfirm - <packages/development.txt
yay -S --needed --noconfirm - <packages/system.txt
yay -S --needed --noconfirm - <packages/wm.txt
yay -S --needed --noconfirm - <packages/productivity.txt
yay -S --needed --noconfirm - <packages/entertainment.txt
yay -S --needed --noconfirm - <packages/misc.txt

cp -r .config $HOME
cp -r ./configurations/texmf $HOME
texhash $HOME/texmf

# Applications
sudo npm install -g @google/gemini-cli

mkdir $HOME/Documents
mkdir $HOME/Screenshots
mkdir $HOME/Downloads

./scripts/browser.sh
./scripts/default.sh
./scripts/dwm.sh
./scripts/firewall.sh
./scripts/fonts.sh
./scripts/librepods.sh
./scripts/mprisence.sh
./scripts/setup.fish
./scripts/syncthing.sh
./scripts/theme.sh
./scripts/yay.sh
./scripts/zathura.sh
