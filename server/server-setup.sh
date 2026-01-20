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
mkdir -p $HOME/Caddy /etc/caddy /var/log/caddy
(
    cd $HOME/Caddy
    xcaddy build \
        --with github.com/mholt/caddy-dynamicdns \
        --with github.com/caddy-dns/cloudflare \
        --with github.com/jpillora/ipfilter-caddy
    sudo mv caddy /usr/bin/
    sudo groupadd --system caddy
    sudo useradd --system \
        --gid caddy \
        --create-home \
        --home-dir /var/lib/caddy \
        --shell /usr/sbin/nologin \
        --comment "Caddy web server" \
        caddy
    sudo setcap cap_net_bind_service+ep /usr/bin/caddy
    sudo chown -R caddy:caddy /etc/caddy /var/log/caddy /var/lib/caddy
    cat >Caddyfile <<caddy-config
{
	dynamic_dns {
		provider cloudflare TOKEN
		domains {
		    domain.com @
			domain.com sub
		}
		check_interval 5m
	}

	log {
		output file /var/log/caddy/access.log
		format json
		roll_size 10mb
		roll_keep_for 720h
		roll_keep 20
	}
}

(headers) {
	header {
		Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
		X-Frame-Options "SAMEORIGIN"
		X-Content-Type-Options "nosniff"
		-Server
	}
}

domain.com {
	import headers
	trusted_proxies cloudflare

	@is_foreign_threat {
		not remote_ip private_ranges
		not ipfilter_geolocation {
			allow_countries AU
		}
	}

	handle @is_foreign_threat {
		respond "Access Restricted" 403
	}

	handle {
		reverse_proxy IP:PORT
	}

	handle_errors {
		@denied expression {err.status_code} == 403
		respond @denied "Access restricted" 403
	}
}
caddy-config
sudo cp Caddyfile /etc/caddy/Caddyfile
)
sudo curl -o /etc/systemd/system/caddy.service https://raw.githubusercontent.com/caddyserver/dist/refs/heads/master/init/caddy.service
sudo ufw allow 443,80/tcp
sudo systemctl enable --now caddy.service

echo "
███████████            ███  ████   ████████  █████
░░███░░░░░░█           ░░░  ░░███  ███░░░░███░░███
░███   █ ░   ██████   ████  ░███ ░░░    ░███ ░███████   ██████   ████████
░███████    ░░░░░███ ░░███  ░███    ███████  ░███░░███ ░░░░░███ ░░███░░███
░███░░░█     ███████  ░███  ░███   ███░░░░   ░███ ░███  ███████  ░███ ░███
░███  ░     ███░░███  ░███  ░███  ███      █ ░███ ░███ ███░░███  ░███ ░███
█████      ░░████████ █████ █████░██████████ ████████ ░░████████ ████ █████
░░░░░        ░░░░░░░░ ░░░░░ ░░░░░ ░░░░░░░░░░ ░░░░░░░░   ░░░░░░░░ ░░░░ ░░░░░
"
mkdir -p $HOME/fail2ban
(
    cd $HOME/fail2ban
    cat >caddy-403.conf <<fail2ban-caddy
[Definition]
failregex = ^.*"client_ip":"<HOST>",.*?"status":403,.*$

datepattern = LongEpoch
fail2ban-caddy
    cat >caddy.local <<fail2ban-jail-caddy
[caddy-403]
enabled = true
port = http,https
filter = caddy-403
logpath = /var/log/caddy/access.log
maxretry = 5
findtime = 10m
bantime = 1d
banaction = ufw
fail2ban-jail-caddy
sudo cp caddy-403.conf /etc/fail2ban/filter.d/caddy-403.conf
sudo cp caddy.local /etc/fail2ban/jail.d/caddy.local
sudo systemctl enable --now fail2ban
)

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

echo "
█████   ████                               █████
░░███   ███░                               ░░███
░███  ███     ██████   ████████   ██████   ░███ █████  ██████   ██████  ████████
░███████     ░░░░░███ ░░███░░███ ░░░░░███  ░███░░███  ███░░███ ███░░███░░███░░███
░███░░███     ███████  ░███ ░░░   ███████  ░██████░  ░███████ ░███████  ░███ ░███
░███ ░░███   ███░░███  ░███      ███░░███  ░███░░███ ░███░░░  ░███░░░   ░███ ░███
█████ ░░████░░████████ █████    ░░████████ ████ █████░░██████ ░░██████  ░███████
░░░░░   ░░░░  ░░░░░░░░ ░░░░░      ░░░░░░░░ ░░░░ ░░░░░  ░░░░░░   ░░░░░░   ░███░░░
                                                                        ░███
                                                                        █████
                                                                       ░░░░░
"
if [ -d "$HOME/karakeep" ]; then
  echo "Directory exists. Moving..."
  mv "$HOME/karakeep" "$HOME/karakeep.old"
  mkdir -p "$HOME/karakeep"
else
  echo "Directory does not exist. Creating..."
  mkdir -p "$HOME/karakeep"
fi

(
  cd $HOME/karakeep
  wget https://raw.githubusercontent.com/karakeep-app/karakeep/main/docker/docker-compose.yml
  echo "Karakeep setup"
  read -p "Enter NEXTAUTH secret (defaults to random string): " nextauth_string_input
  KARAKEEP_NEXTAUTH_SECRET=${nextauth_string_input:-$(openssl rand -base64 36)}
  read -p "Enter Meili key (defaults to random string): " meilikey_string_input
  KARAKEEP_MEILI_KEY=${meilikey_string_input:-$(openssl rand -base64 36)}
  read -p "Enter the port to listen on (default 1000): " karakeep_port_input
  KARAKEEP_PORT=${karakeep_port_input:-1000}
  sed -i "s/3000:3000/$KARAKEEP_PORT:3000/" docker-compose.yml
  cat >".env" <<karakeep-env
KARAKEEP_VERSION=release
NEXTAUTH_SECRET=$KARAKEEP_NEXTAUTH_SECRET
MEILI_MASTER_KEY=$KARAKEEP_MEILI_KEY
NEXTAUTH_URL=http://$KARAKEEP_URL:$KARAKEEP_PORT
karakeep-env
  sudo ufw allow $KARAKEEP_PORT/tcp
  echo "This is your NextAuth Secret: "$KARAKEEP_NEXTAUTH_SECRET" Copy it down."
  echo "This is your Meili Master Key: "$KARAKEEP_MEILI_KEY" Copy it down."
  sudo docker compose up -d
)

echo "
█████████                                                               █████
███░░░░░███                                                             ░░███
███     ░░░   ██████  ████████  █████ ████ ████████   ██████   ████████  ███████   █████ ████
░███          ███░░███░░███░░███░░███ ░███ ░░███░░███ ░░░░░███ ░░███░░███░░░███░   ░░███ ░███
░███         ░███ ░███ ░███ ░███ ░███ ░███  ░███ ░███  ███████  ░███ ░░░   ░███     ░███ ░███
░░███     ███░███ ░███ ░███ ░███ ░███ ░███  ░███ ░███ ███░░███  ░███       ░███ ███ ░███ ░███
░░█████████ ░░██████  ░███████  ░░███████  ░███████ ░░████████ █████      ░░█████  ░░███████
░░░░░░░░░   ░░░░░░   ░███░░░    ░░░░░███  ░███░░░   ░░░░░░░░ ░░░░░        ░░░░░    ░░░░░███
                    ░███       ███ ░███  ░███                                     ███ ░███
                    █████     ░░██████   █████                                   ░░██████
                   ░░░░░       ░░░░░░   ░░░░░                                     ░░░░░░
"
mkdir -p $HOME/.config/copyparty
mkdir -p /hdd/media /hdd/music /hdd/webdav /hdd/documents /hdd/downloads
echo "Copyparty setup"
read -p "Enter the port to listen on (default 2000): " copyparty_port_input
COPYPARTY_PORT=${copyparty_port_input:-2000}
read -p "Enter admin account password: " copyparty_admin_pass
COPYPARTY_PASSWORD_ADMIN=${copyparty_admin_pass:-$(openssl rand -base64 36)}
read -p "Enter user account password: " copyparty_user_pass
COPYPARTY_PASSWORD_USER=${copyparty_user_pass:-$(openssl rand -base64 36)}
read -p "Enter webdav account password: " copyparty_webdav_pass
COPYPARTY_PASSWORD_WEBDAV=${copyparty_webdav_pass:-$(openssl rand -base64 36)}
cat >$HOME/copyparty-credentials <<copyparty-credentials
admin: $COPYPARTY_PASSWORD_ADMIN
user: $COPYPARTY_PASSWORD_USER
webdav: $COPYPARTY_PASSWORD_WEBDAV
copyparty-credentials
echo "Your credentials have been copied to $HOME/copyparty-credentials"
cat >$HOME/.config/copyparty/copyparty.conf <<copyparty-config
[global]
  p: $COPYPARTY_PORT
  e2dsa  # enable file indexing and filesystem scanning
  z, qr  # and zeroconf and qrcode (you can comma-separate arguments)

[accounts]
  admin: $COPYPARTY_PASSWORD_ADMIN
  user: $COPYPARTY_PASSWORD_USER
  webdav: $COPYPARTY_PASSWORD_WEBDAV

# create volumes:
[/hdd]
    /hdd
    accs:
        r: user
        a: admin

[/downloads]
    /hdd/downloads
    accs:
        rwmd: user, admin
        a: admin

[/documents]
    /hdd/documents
    accs:
        rwmd: user, admin
        a: admin

[/music]
    /hdd/music
    accs:
        rwmd: user, admin
        a: admin

[/media]
    /hdd/media
    accs:
        rwmd: user, admin
        a: admin

[/webdav]
    /hdd/webdav
    accs:
        rwd: webdav
        rwmd: user, admin
        a: admin
copyparty-config
sudo systemctl enable --now copyparty@$USER.service
sudo mkdir -p /etc/copyparty
sudo cp $HOME/.config/copyparty/copyparty.conf /etc/copyparty/copyparty.conf
sudo ufw allow $COPYPARTY_PORT

echo "
███████                                   ████                        ██████
███░░░░░███                                ░░███                       ███░░███
███     ░░███ █████ █████  ██████  ████████  ░███   ██████   ██████    ░███ ░░░
░███      ░███░░███ ░░███  ███░░███░░███░░███ ░███  ███░░███ ░░░░░███  ███████
░███      ░███ ░███  ░███ ░███████  ░███ ░░░  ░███ ░███████   ███████ ░░░███░
░░███     ███  ░░███ ███  ░███░░░   ░███      ░███ ░███░░░   ███░░███   ░███
░░░███████░    ░░█████   ░░██████  █████     █████░░██████ ░░████████  █████
░░░░░░░       ░░░░░     ░░░░░░  ░░░░░     ░░░░░  ░░░░░░   ░░░░░░░░  ░░░░░

"
if [ -d "$HOME/overleaf" ]; then
  echo "Directory exists. Moving..."
  mv "$HOME/overleaf" "$HOME/overleaf.old"
  git clone https://github.com/overleaf/toolkit $HOME/overleaf
else
  echo "Directory does not exist. Creating..."
  git clone https://github.com/overleaf/toolkit $HOME/overleaf
fi
(
  cd $HOME/overleaf
  bin/init
  read -p "Enter Overleaf Project Name (defaults to overleaf-extended): " input_project
  OVERLEAF_PROJECT_NAME=${input_project:-overleaf-extended}
  read -p "Enter Overleaf App Name (defaults to Overleaf Community Extended): " input_appname
  OVERLEAF_APP_NAME=${input_appname:-Overleaf Community Extended}
  read -p "Enter Overleaf Port (defaults to 3000): " input_port
  OVERLEAF_PORT=${input_port:-3000}
  read -p "Enter Overleaf listening IP (defaults to 0.0.0.0): " input_listening_ip
  OVERLEAF_LISTEN_IP=${input_listening_ip:-0.0.0.0}
  read -p "Enter Overleaf site url: " input_url
  OVERLEAF_SITE_URL=${input_url:-localhost://}

  cat >./config/overleaf.rc <<overleaf-config
#### Overleaf RC ####

PROJECT_NAME=$OVERLEAF_PROJECT_NAME
OVERLEAF_DATA_PATH=data/overleaf
SERVER_PRO=false
OVERLEAF_LISTEN_IP=$OVERLEAF_LISTEN_IP
OVERLEAF_PORT=$OVERLEAF_PORT

SIBLING_CONTAINERS_ENABLED=false
DOCKER_SOCKET_PATH=/var/run/docker.sock

MONGO_ENABLED=true
MONGO_DATA_PATH=data/mongo
MONGO_IMAGE=mongo
MONGO_VERSION=8.0

REDIS_ENABLED=true
REDIS_DATA_PATH=data/redis
REDIS_IMAGE=redis:7.4
REDIS_AOF_PERSISTENCE=true

GIT_BRIDGE_ENABLED=false

NGINX_ENABLED=false
overleaf-config
  cat >./config/variables.env <<overleaf_variables
OVERLEAF_APP_NAME="$OVERLEAF_APP_NAME"
OVERLEAF_SITE_URL=$OVERLEAF_SITE_URL

ENABLED_LINKED_FILE_TYPES=project_file,project_output_file

ENABLE_CONVERSIONS=false
EMAIL_CONFIRMATION_DISABLED=true
################
## Server Pro ##
################

EXTERNAL_AUTH=none

#################
#   TEMPLATES   #
#################

ENABLE_CONVERSIONS=true

OVERLEAF_TEMPLATE_GALLERY=true
OVERLEAF_NON_ADMIN_CAN_PUBLISH_TEMPLATES=true
OVERLEAF_TEMPLATE_CATEGORIES=General

TEMPLATE_ACADEMIC_JOURNAL_NAME=General
TEMPLATE_ACADEMIC_JOURNAL_DESCRIPTION=Some general templates
overleaf_variables
  cat >./config/docker-compose.override.yml <<docker-override
---
services:
    sharelatex:
        image: overleafcep/sharelatex:6.0.1-ext-v3.3
docker-override
  sudo ufw allow $OVERLEAF_PORT
  sudo bin/up -d
)

echo "
█████   █████ ██████████ ███████████   ███████████            █████
░░███   ░░███ ░░███░░░░░█░░███░░░░░███ ░█░░░███░░░█           ░░███
░███    ░███  ░███  █ ░  ░███    ░███ ░   ░███  ░      █████  ░███████
░███    ░███  ░██████    ░██████████      ░███        ███░░   ░███░░███
░░███   ███   ░███░░█    ░███░░░░░███     ░███       ░░█████  ░███ ░███
 ░░░█████░    ░███ ░   █ ░███    ░███     ░███        ░░░░███ ░███ ░███
   ░░███      ██████████ █████   █████    █████    ██ ██████  ████ █████
    ░░░      ░░░░░░░░░░ ░░░░░   ░░░░░    ░░░░░    ░░ ░░░░░░  ░░░░ ░░░░░
"
if [ -d "$HOME/vert" ]; then
  echo "Directory exists. Moving..."
  mv "$HOME/vert" "$HOME/vert.old"
  git clone https://github.com/VERT-sh/VERT $HOME/vert
else
  echo "Directory does not exist. Creating..."
  git clone https://github.com/VERT-sh/VERT $HOME/vert
fi
(
  cd $HOME/vert
  read -p "Enter the port to listen on (default 4000): " vert_port_input
  VERT_PORT=${vert_port_input:-4000}
  sudo docker build -t vert-sh/vert \
    --build-arg PUB_ENV=production \
    --build-arg PUB_HOSTNAME=vert.sh \
    --build-arg PUB_PLAUSIBLE_URL=https://plausible.example.com \
    --build-arg PUB_VERTD_URL=https://vertd.vert.sh \
    --build-arg PUB_DONATION_URL=https://donations.vert.sh \
    --build-arg PUB_DISABLE_ALL_EXTERNAL_REQUESTS=false \
    --build-arg PUB_STRIPE_KEY="" .
  sudo docker run -d \
    --restart unless-stopped \
    -p $VERT_PORT:80 \
    --name "vert" \
    vert-sh/vert
)

echo "
  █████████   █████     ███            ████   ███                         ███████████  ██████████   ███████████
 ███░░░░░███ ░░███     ░░░            ░░███  ░░░                         ░░███░░░░░███░░███░░░░███ ░░███░░░░░░█
░███    ░░░  ███████   ████  ████████  ░███  ████  ████████    ███████    ░███    ░███ ░███   ░░███ ░███   █ ░
░░█████████ ░░░███░   ░░███ ░░███░░███ ░███ ░░███ ░░███░░███  ███░░███    ░██████████  ░███    ░███ ░███████
 ░░░░░░░░███  ░███     ░███  ░███ ░░░  ░███  ░███  ░███ ░███ ░███ ░███    ░███░░░░░░   ░███    ░███ ░███░░░█
 ███    ░███  ░███ ███ ░███  ░███      ░███  ░███  ░███ ░███ ░███ ░███    ░███         ░███    ███  ░███  ░
░░█████████   ░░█████  █████ █████     █████ █████ ████ █████░░███████    █████        ██████████   █████
 ░░░░░░░░░     ░░░░░  ░░░░░ ░░░░░     ░░░░░ ░░░░░ ░░░░ ░░░░░  ░░░░░███   ░░░░░        ░░░░░░░░░░   ░░░░░
                                                              ███ ░███
                                                             ░░██████
                                                              ░░░░░░
"
if [ -d "$HOME/stirling-pdf" ]; then
  echo "Directory exists. Moving..."
  mv "$HOME/stirling-pdf" "$HOME/stirling-pdf.old"
  mkdir -p $HOME/stirling-pdf
else
  echo "Directory does not exist. Creating..."
  mkdir -p $HOME/stirling-pdf
fi
(
  cd $HOME/stirling-pdf
  read -p "Enter the port to listen on (default 5000): " stirling_port_input
  STIRLING_PORT=${stirling_port_input:-5000}
  cat >docker-compose.yml <<stirling-pdf
services:
    stirling-pdf:
        image: stirlingtools/stirling-pdf:latest-ultra-lite
        container_name: stirling-pdf
        ports:
            - '$STIRLING_PORT:8080'
        volumes:
            - ./stirling-data:/configs
        restart: unless-stopped
stirling-pdf
  sudo docker compose up -d
)
echo "
█████                                  ███           █████
░░███                                  ░░░           ░░███
░███  █████████████   █████████████   ████   ██████  ░███████
░███ ░░███░░███░░███ ░░███░░███░░███ ░░███  ███░░███ ░███░░███
░███  ░███ ░███ ░███  ░███ ░███ ░███  ░███ ░███ ░░░  ░███ ░███
░███  ░███ ░███ ░███  ░███ ░███ ░███  ░███ ░███  ███ ░███ ░███
█████ █████░███ █████ █████░███ █████ █████░░██████  ████ █████
░░░░░ ░░░░░ ░░░ ░░░░░ ░░░░░ ░░░ ░░░░░ ░░░░░  ░░░░░░  ░░░░ ░░░░░
"
mkdir /hdd/immich
(
  cd /hdd/immich
  wget -O docker-compose.yml https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
  wget -O .env https://github.com/immich-app/immich/releases/latest/download/example.env
  read -p "Enter the port to listen on (defaults to 6000): " immich_port_input
  IMMICH_PORT=${immich_port_input:-6000}
  read -p "Enter timezone https://en.wikipedia.org/wiki/List_of_tz_database_time_zones (defaults to Australia/Sydney): " immich_tz_input
  IMMICH_TZ=${immich_tz_input:-Australia/Sydney}
  read -p "Enter postgres password secret (defaults to random string): " immich_postgres_pw_input
  IMMICH_POSTGRES_PW=${immich_postgres_pw_input:-$(openssl rand -base64 36)}
  sed -i "s/# TZ=Etc/UTC/TZ=$IMMICH_TZ/" .env
  sed -i "s/DB_PASSWORD=postgres/DB_PASSWORD=$IMMICH_POSTGRES_PW/" .env
  sed -i "s/2283:2283/$IMMICH_PORT:2283/" docker-compose.yml
  sudo ufw allow $IMMICH_PORT
  sudo docker compose up -d
)

echo "
                               █████
                              ░░███
 █████████████   ████████   ███████
░░███░░███░░███ ░░███░░███ ███░░███
 ░███ ░███ ░███  ░███ ░███░███ ░███
 ░███ ░███ ░███  ░███ ░███░███ ░███
 █████░███ █████ ░███████ ░░████████
░░░░░ ░░░ ░░░░░  ░███░░░   ░░░░░░░░
                 ░███
                 █████
                ░░░░░
"
mkdir -p $HOME/.config/mpd
mkdir -p /hdd/music
mkdir -p /hdd/mpd
read -p "Enter the port to listen on (default 7000): " mpd_port_input
MPD_PORT=${mpd_port_input:-7000}
read -p "Enter the IP to listen on (default 0.0.0.0): " mpd_ip_input
MPD_LISTENING_IP=${mpd_ip_input:-0.0.0.0}
cat >$HOME/.config/mpd/mpd.conf <<mpd-config
music_directory         "/hdd/music"
playlist_directory      "/hdd/mpd/playlists"
db_file                 "/hdd/mpd/tag_cache"
pid_file                "/hdd/mpd/pid"
state_file              "/hdd/mpd/state"
sticker_file            "/hdd/mpd/sticker.sql"
bind_to_address         "$MPD_LISTENING_IP"
port                    "$MPD_PORT"
bind_to_address         "/hdd/mpd/socket"

audio_output {
    type        "httpd"
    name        "mpd server"
    encoder     "lame"      # Needs 'lame' installed
    bitrate     "128"
    format      "44100:16:1"
    always_on   "yes"       # prevent MPD from disconnecting on pause
    tags        "yes"       # httpd supports sending tags to listening streams.
}
mpd-config
sudo ufw allow $MPD_PORT
sudo cp $HOME/.config/mpd/mpd.conf /etc/mpd.conf
sudo systemctl enable --now mpd.service
