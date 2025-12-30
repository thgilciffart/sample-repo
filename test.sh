#!/bin/sh

syncthing -no-browser -no-restart >/dev/null 2>&1 </dev/null &
sleep 10
pkill syncthing
sed -i 's/127.0.0.1/0.0.0.0/' $HOME/.local/state/syncthing/config.xml
echo "Syncthing configuration done"
