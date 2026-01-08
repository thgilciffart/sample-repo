#!/bin/sh
mkdir -p "$HOME/karakeep"
(cd "$HOME/karakeep" && wget https://raw.githubusercontent.com/karakeep-app/karakeep/main/docker/docker-compose.yml)
read -p "Enter NEXTAUTH secret (defaults to random string): " nextauth_string
NEXT_AUTH_SECRET_VAR=${nextauth_string:-$(openssl rand -base64 36)}
read -p "Enter Meili key (defaults to random string): " meilikey_string
MEILI_KEY_VAR=${meilikey_string:-$(openssl rand -base64 36)}
read -p "Enter the port to listen on (default 3000): " port_input
PORT_VAR=${port_input:-3000}
read -p "Enter the listening URL (default 127.0.0.1): " url_input
URL_VAR=${url_input:-127.0.0.1}

cat > "$HOME/karakeep/.env" <<karakeep-env
KARAKEEP_VERSION=release
NEXTAUTH_SECRET=$NEXT_AUTH_SECRET_VAR
MEILI_MASTER_KEY=$MEILI_KEY_VAR
NEXTAUTH_URL=http://$URL_VAR:$PORT_VAR
karakeep-env
echo "This is your NextAuth Secret: $NEXT_AUTH_SECRET_VAR, copy it down."
echo "This is your Meili Master Key: $MEILI_KEY_VAR, copy it down."
