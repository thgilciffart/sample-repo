mkdir -p $HOME/.config /copyparty
read -p "Enter admin account password " copyparty_admin_pass
COPYPARTY_PASSWORD_ADMIN=${copyparty_admin_pass:-$(openssl rand -base64 36)}
read -p "Enter user account password " copyparty_user_pass
COPYPARTY_PASSWORD_USER=${copyparty_user_pass:-$(openssl rand -base64 36)}
read -p "Enter webdav account password " copyparty_webdav_pass
COPYPARTY_PASSWORD_WEBDAV=${copyparty_webdav_pass:-$(openssl rand -base64 36)}

cat > $HOME/.config/copyparty/copyparty.conf <<copyparty-config
[global]
  p:
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
