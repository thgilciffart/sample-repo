#!/bin/sh

# Install server packages

yay -S --needed - <server-packages.txt

# Docker set up
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service

# Karakeep

# Copyparty

# nginx proxy manager

# overleaf
mkdir $HOME/overleaf
git clone https://github.com/overleaf/toolkit $HOME/overleaf
$HOME/overleaf/bin/init

# asking users to configure
read -p "Enter Overleaf Project Name (defaults to overleaf-extended): " input_project
PROJECT_NAME=${input_project:-overleaf-extended}
read -p "Enter Overleaf App Name (defaults to Overleaf Community Extended): " input_appname
APP_NAME=${input_appname:-Overleaf Community Extended}
read -p "Enter Overleaf Port (defaults to 4000): " input_port
PORT=${input_port:-4000}
read -p "Enter Overleaf listening IP (defaults to 127.0.0.1): " input_listening_ip
LISTEN_IP=${input_listening_ip:-127.0.0.1}
read -p "Enter Overleaf site url: " input_url
SITE_URL=${input_url:-localhost://}

cat >$HOME/overleaf/config/overleaf.rc <<overleaf-config # overleaf.rc config
#### Overleaf RC ####

PROJECT_NAME=$PROJECT_NAME
OVERLEAF_DATA_PATH=data/overleaf
SERVER_PRO=false
OVERLEAF_LISTEN_IP=$LISTEN_IP
OVERLEAF_PORT=$PORT

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
cat >$HOME/overleaf/config/variables.env <<variables # variables.env config
OVERLEAF_APP_NAME="$APP_NAME"
OVERLEAF_SITE_URL=$SITE_URL

ENABLED_LINKED_FILE_TYPES=project_file,project_output_file

ENABLE_CONVERSIONS=false
EMAIL_CONFIRMATION_DISABLED=true
################
## Server Pro ##
################

EXTERNAL_AUTH=none
variables
cat >$HOME/overleaf/config/docker-compose.override.yml <<docker-override # use overleaf extended image
---
services:
  sharelatex:
    image: overleafcep/sharelatex:6.0.1-ext-v3.3
docker-override
$HOME/overleaf/bin/up -d
# syncthing

# mpd server

#
# misc. services
