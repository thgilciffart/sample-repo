#!/bin/sh
rm -rf /tmp/librepods
git clone https://github.com/kavishdevar/librepods.git /tmp/librepods
cd /tmp/librepods/linux
mkdir /tmp/librepods/linux/build
cd /tmp/librepods/linux/build
cmake ..
make -j $(nproc)
sudo cp /tmp/librepods/linux/build/librepods /usr/local/bin

mkdir -p ~/.local/share/applications
touch ~/.local/share/applications/librepods.desktop
cat >~/.local/share/applications/librepods.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=Librepods 
Exec=/usr/local/bin/librepods
Terminal=false
Categories=Utility;
EOF

chmod +x ~/.local/share/applications/librepods.desktop
