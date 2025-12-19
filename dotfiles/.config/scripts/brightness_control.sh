#!/bin/bash
# Brightness control script using brightnessctl and dunstify
# Usage: ./brightness.sh [up|down]

# Get current brightness percentage
get_brightness() {
  local current=$(brightnessctl get)
  local max=$(brightnessctl max)
  echo $((current * 100 / max))
}

# Send notification with progress bar
notify_brightness() {
  local brightness=$(get_brightness)

  dunstify -a "brightness" -u normal -h string:x-dunst-stack-tag:brightness \
    -h int:value:"$brightness" "Brightness: ${brightness}%" -t 2000
}

# Main logic
case "$1" in
up)
  brightnessctl set +1%
  notify_brightness
  ;;
down)
  brightnessctl set 1%-
  notify_brightness
  ;;
*)
  echo "Usage: $0 {up|down}"
  exit 1
  ;;
esac

