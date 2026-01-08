#!/bin/sh

# Install server packages

yay -S --needed - <./server-packages.txt

# Docker set up
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service

# Authentik Set up
if [ -d "$HOME/authentik" ]; then
    echo "Directory exists. Moving..."
    mv "$HOME/authentik" "$HOME/authentik.old"
    mkdir -p "$HOME/authentik"
else
    echo "Directory does not exist. Creating..."
    mkdir -p "$HOME/authentik"
fi
(
    cd $HOME/authentik
    wget https://docs.goauthentik.io/docker-compose.yml
    echo "PG_PASS=$(openssl rand -base64 36 | tr -d '\n')" >> .env
    echo "AUTHENTIK_SECRET_KEY=$(openssl rand -base64 60 | tr -d '\n')" >> .env
    docker compose pull
    docker compose up -d
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

    read -p "Enter NEXTAUTH secret (defaults to random string): " nextauth_string
    KARAKEEP_NEXTAUTH_SECRET=${nextauth_string:-$(openssl rand -base64 36)}
    read -p "Enter Meili key (defaults to random string): " meilikey_string
    KARAKEEP_MEILI_KEY=${meilikey_string:-$(openssl rand -base64 36)}
    read -p "Enter the port to listen on (default 3000): " port_input
    KARAKEEP_PORT=${port_input:-3000}
    read -p "Enter the listening URL (default 127.0.0.1): " url_input
    KARAKEEP_URL=${url_input:-127.0.0.1}

    cat > ".env" <<karakeep-env
KARAKEEP_VERSION=release
NEXTAUTH_SECRET=$KARAKEEP_NEXTAUTH_SECRET
MEILI_MASTER_KEY=$KARAKEEP_MEILI_KEY
NEXTAUTH_URL=http://$KARAKEEP_URL:$KARAKEEP_PORT
karakeep-env
    sudo ufw allow $KARAKEEP_PORT/tcp
    echo "This is your NextAuth Secret: "$KARAKEEP_NEXTAUTH_SECRET" Copy it down."
    echo "This is your Meili Master Key: "$KARAKEEP_MEILI_KEY" Copy it down."
    docker compose up -d
)


# Copyparty

# nginx proxy manager

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
    read -p "Enter Overleaf Port (defaults to 4000): " input_port
    OVERLEAF_PORT=${input_port:-4000}
    read -p "Enter Overleaf listening IP (defaults to 127.0.0.1): " input_listening_ip
    OVERLEAF_LISTEN_IP=${input_listening_ip:-127.0.0.1}
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
    sudo ufw allow $OVERLEAF_PORT/tcp
    bin/up -d
)

# syncthing

# mpd server

#
# misc. services
