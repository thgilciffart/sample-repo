#!/bin/sh
mkdir -p ~/.config/mprisence
curl -o ~/.config/mprisence/config.toml https://raw.githubusercontent.com/lazykern/mprisence/main/config/config.default.toml
mkdir -p ~/.mpdscribble
cp /usr/share/mpdscribble/mpdscribble.conf.example ~/.mpdscribble/mpdscribble.conf

systemctl --user enable --now mprisence.service
systemctl --user enable --now mpd.service
systemctl --user enable --now mpd-mpris.service
systemctl --user enable --now mpdscribble.service
