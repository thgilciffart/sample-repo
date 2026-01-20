#!/bin/bash

echo "
█████████                      █████                                                  █████
███░░░░░███                    ░░███                                                  ░░███
░███    ░░░  █████ ████  █████  ███████    ██████  █████████████       █████   ██████  ███████   █████ ████ ████████
░░█████████ ░░███ ░███  ███░░  ░░░███░    ███░░███░░███░░███░░███     ███░░   ███░░███░░░███░   ░░███ ░███ ░░███░░███
░░░░░░░░███ ░███ ░███ ░░█████   ░███    ░███████  ░███ ░███ ░███    ░░█████ ░███████   ░███     ░███ ░███  ░███ ░███
███    ░███ ░███ ░███  ░░░░███  ░███ ███░███░░░   ░███ ░███ ░███     ░░░░███░███░░░    ░███ ███ ░███ ░███  ░███ ░███
░░█████████  ░░███████  ██████   ░░█████ ░░██████  █████░███ █████    ██████ ░░██████   ░░█████  ░░████████ ░███████
░░░░░░░░░    ░░░░░███ ░░░░░░     ░░░░░   ░░░░░░  ░░░░░ ░░░ ░░░░░    ░░░░░░   ░░░░░░     ░░░░░    ░░░░░░░░  ░███░░░
            ███ ░███                                                                                      ░███
           ░░██████                                                                                       █████
            ░░░░░░                                                                                       ░░░░░
"
echo "Installing AUR packages"
yay -S --needed $(<server-pkglist.txt)
echo "Enabling linger for current user"
sudo loginctl enable-linger $USER

echo "
█████████       █████   █████████                                     █████    █████   █████
███░░░░░███     ░░███   ███░░░░░███                                   ░░███    ░░███   ░░███
░███    ░███   ███████  ███     ░░░  █████ ████  ██████   ████████   ███████     ░███    ░███   ██████  █████████████    ██████
░███████████  ███░░███ ░███         ░░███ ░███  ░░░░░███ ░░███░░███ ███░░███     ░███████████  ███░░███░░███░░███░░███  ███░░███
░███░░░░░███ ░███ ░███ ░███    █████ ░███ ░███   ███████  ░███ ░░░ ░███ ░███     ░███░░░░░███ ░███ ░███ ░███ ░███ ░███ ░███████
░███    ░███ ░███ ░███ ░░███  ░░███  ░███ ░███  ███░░███  ░███     ░███ ░███     ░███    ░███ ░███ ░███ ░███ ░███ ░███ ░███░░░
█████   █████░░████████ ░░█████████  ░░████████░░████████ █████    ░░████████    █████   █████░░██████  █████░███ █████░░██████
░░░░░   ░░░░░  ░░░░░░░░   ░░░░░░░░░    ░░░░░░░░  ░░░░░░░░ ░░░░░      ░░░░░░░░    ░░░░░   ░░░░░  ░░░░░░  ░░░░░ ░░░ ░░░░░  ░░░░░░
"

curl -L https://static.adguard.com/adguardhome/release/AdGuardHome_linux_386.tar.gz | tar -xz -C $HOME
(
    cd $HOME/AdGuardHome
    sudo ./AdGuardHome -s install
    sudo ufw allow 81
    sudo ufw allow 53
)

echo "
█████████                █████     █████
███░░░░░███              ░░███     ░░███
███     ░░░   ██████    ███████   ███████  █████ ████
░███          ░░░░░███  ███░░███  ███░░███ ░░███ ░███
░███           ███████ ░███ ░███ ░███ ░███  ░███ ░███
░░███     ███ ███░░███ ░███ ░███ ░███ ░███  ░███ ░███
░░█████████ ░░████████░░████████░░████████ ░░███████
░░░░░░░░░   ░░░░░░░░  ░░░░░░░░  ░░░░░░░░   ░░░░░███
                                          ███ ░███
                                         ░░██████
                                          ░░░░░░
"
mkdir -p $HOME/Caddy
(
    cd $HOME/Caddy
    xcaddy build \
        --with github.com/mholt/caddy-dynamicdns \
        --with github.com/caddy-dns/cloudflare \
        --with github.com/jpillora/ipfilter-caddy
    sudo mv /usr/bin/
    sudo groupadd --system caddy
    sudo useradd --system \
        --gid caddy \
        --create-home \
        --home-dir /var/lib/caddy \
        --shell /usr/sbin/nologin \
        --comment "Caddy web server" \
        caddy
    sudo chown -R caddy:caddy $HOME/user/Caddy
    cat >Caddyfile <<caddy-config
)
sudo curl -o /etc/systemd/system/caddy.service https://raw.githubusercontent.com/caddyserver/dist/refs/heads/master/init/caddy.service
sudo sed -i "s|/etc/caddy/Caddyfile|$HOME/Caddy/Caddyfile|gI" /usr/lib/systemd/system/caddy.service
sudo systemctl enable --now caddy.service

echo "
██████████                     █████
░░███░░░░███                   ░░███
░███   ░░███  ██████   ██████  ░███ █████  ██████  ████████
░███    ░███ ███░░███ ███░░███ ░███░░███  ███░░███░░███░░███
░███    ░███░███ ░███░███ ░░░  ░██████░  ░███████  ░███ ░░░
░███    ███ ░███ ░███░███  ███ ░███░░███ ░███░░░   ░███
██████████  ░░██████ ░░██████  ████ █████░░██████  █████
░░░░░░░░░░    ░░░░░░   ░░░░░░  ░░░░ ░░░░░  ░░░░░░  ░░░░░
"
sudo groupadd -f docker
sudo usermod -aG docker $USER
sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service
