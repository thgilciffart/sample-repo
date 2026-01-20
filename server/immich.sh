#!/bin/sh

mkdir /hdd/immich
(
  cd /hdd/immich
  wget -O docker-compose.yml https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
  wget -O .env https://github.com/immich-app/immich/releases/latest/download/example.env
)
