#!/bin/sh

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
echo $PROJECT_NAME $APP_NAME $PORT $LISTEN_IP $SITE_URL
