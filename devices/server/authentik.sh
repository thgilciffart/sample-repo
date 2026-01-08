
if [ -d "$HOME/karakeep" ]; then
    echo "Directory exists. Moving..."
    mv "$HOME/karakeep" "HOME/karakeep.old"
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

    cat > .env <<karakeep-env
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
