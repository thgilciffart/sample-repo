#!/bin/sh

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
