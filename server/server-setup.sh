#!/bin/bash
# Install server packages

yay -S --needed - <./server-packages.txt

# Docker set up
sudo groupadd -f docker
sudo usermod -aG docker $USER
sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service

## ddclient
sudo mkdir -p /etc/ddclient
cat <<ddclient-config | sudo tee /etc/ddclient/ddclient.conf > /dev/null
daemon=300                      # check every 300 seconds
syslog=yes                      # log update msgs to syslog
mail=root                       # mail all msgs to root
mail-failure=root               # mail failed update msgs to root
pid=/var/run/ddclient.pid

##
## CloudFlare (www.cloudflare.com)
##
protocol=cloudflare,
zone=DOMAIN_0.COM,
ttl=1,
password='CLOUDFLARE TOKEN'
SUBDOMAIN_DOMAIN_0.COM

protocol=cloudflare,
zone=DOMAIN_1.COM,
ttl=1,
password='CLOUDFLARE TOKEN'
SUBDOMAIN.DOMAIN_1.COM
ddclient-config
sudo systemctl enable --now ddclient.service

# nginx proxy manager
if [ -d "$HOME/nginx-proxy-manager" ]; then
    echo "Directory exists. Moving..."
    mv "$HOME/nginx-proxy-manager" "$HOME/nginx-proxy-manager.old"
    mkdir -p "$HOME/nginx-proxy-manager"
else
    echo "Directory does not exist. Creating..."
    mkdir -p "$HOME/nginx-proxy-manager"
fi
(
    cd $HOME/nginx-proxy-manager
    read -p "Enter web UI port (defaults to 81): " nginx_ui_port_input
    NGINX_UI_PORT=${nginx_ui_port_input:-81}
    read -p "Enter time zone https://en.wikipedia.org/wiki/List_of_tz_database_time_zones (defaults to Australia/Sydney): " nginx_timezone_input
    NGINX_TIMEZONE=${nginx_timezone_input:-Australia/Sydney}
    read -p "Disable IPv6? (true/false): " nginx_ipv6_input
    NGINX_IPV6=${nginx_ipv6_input:-true}
    cat > docker-compose.yml <<nginx-config
services:
    app:
        image: 'jc21/nginx-proxy-manager:latest'
        restart: unless-stopped

        ports:
          - '80:80' # Public HTTP Port
          - '443:443' # Public HTTPS Port
          - '$NGINX_UI_PORT:81' # Admin Web Port

        environment:
            TZ: "$NGINX_TIMEZONE"
            DISABLE_IPV6: '$NGINX_IPV6'

        volumes:
            - ./data:/data
            - ./letsencrypt:/etc/letsencrypt
nginx-config
    sudo docker compose up -d
    sudo ufw allow $NGINX_UI_PORT
    sudo ufw allow 443/tcp
    sudo ufw allow 80/tcp
)

# Karakeep
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

    read -p "Enter NEXTAUTH secret (defaults to random string): " nextauth_string_input
    KARAKEEP_NEXTAUTH_SECRET=${nextauth_string_input:-$(openssl rand -base64 36)}
    read -p "Enter Meili key (defaults to random string): " meilikey_string_input
    KARAKEEP_MEILI_KEY=${meilikey_string_input:-$(openssl rand -base64 36)}
    read -p "Enter the port to listen on (default 1000): " karakeep_port_input
    KARAKEEP_PORT=${karakeep_port_input:-1000}
    read -p "Enter the listening URL (default 0.0.0.0): " karakeep_url_input
    KARAKEEP_URL=${karakeep_url_input:-0.0.0.0}

    cat > ".env" <<karakeep-env
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

# Copyparty
mkdir -p $HOME/.config/copyparty
read -p "Enter the port to listen on (default 2000): " copyparty_port_input
COPYPARTY_PORT=${copyparty_port_input:-2000}
read -p "Enter admin account password " copyparty_admin_pass
COPYPARTY_PASSWORD_ADMIN=${copyparty_admin_pass:-$(openssl rand -base64 36)}
read -p "Enter user account password " copyparty_user_pass
COPYPARTY_PASSWORD_USER=${copyparty_user_pass:-$(openssl rand -base64 36)}
read -p "Enter webdav account password " copyparty_webdav_pass
COPYPARTY_PASSWORD_WEBDAV=${copyparty_webdav_pass:-$(openssl rand -base64 36)}

cat > $HOME/.config/copyparty/copyparty.conf <<copyparty-config
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
    /hdd/downloads
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
sudo systemctl enable --now copyparty.service
sudo mkdir -p /etc/copyparty
sudo cp $HOME/.config/copyparty/copyparty.conf /etc/copyparty/copyparty.conf
sudo ufw allow $COPYPARTY_PORT

# overleaf
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
    # asking users to configure
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

# vert.sh
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
# stirling pdf
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

# mpd server
mkdir -p $HOME/.config/mpd
mkdir -p /hdd/music
mkdir -p /hdd/mpd
read -p "Enter the port to listen on (default 6000): " mpd_port_input
MPD_PORT=${mpd_port_input:-6000}
read -p "Enter the IP to listen on (default 0.0.0.0): " mpd_ip_input
MPD_LISTENING_IP=${mpd_ip_input:-0.0.0.0}
cat > $HOME/.config/mpd/mpd.conf <<mpd-config
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

echo "Make sure to manually configure /etc/ddclient/ddclient.conf"