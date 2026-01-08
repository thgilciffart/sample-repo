sudo mv $HOME/authentik $HOME/authentik-old
mkdir -p $HOME/authentik
(cd $HOME/authentik && wget https://docs.goauthentik.io/docker-compose.yml)
(cd $HOME/authentik && echo "PG_PASS=$(openssl rand -base64 36 | tr -d '\n')" >> .env)
(cd $HOME/authentik && echo "AUTHENTIK_SECRET_KEY=$(openssl rand -base64 60 | tr -d '\n')" >> .env)
