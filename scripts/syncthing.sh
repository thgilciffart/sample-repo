#!/bin/sh

systemctl --user enable syncthing.service
systemctl --user start syncthing.service
sleep 5
sed -i 's/127\.0\.0\.1/0.0.0.0/g' $HOME/.local/state/syncthing/config.xml

mkdir -p ~/.local/share/applications
touch ~/.local/share/applications/syncthing.desktop
cat >~/.local/share/applications/syncthing.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=Syncthing
Exec=xdg-open https://localhost:8384
Terminal=false
Categories=Network;Utility;
EOF
