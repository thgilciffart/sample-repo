#!/bin/bash
# Minimal screenshot script for dwm + clipcat
# Takes selection screenshot, saves to file and clipboard

SCREENSHOT_DIR="$HOME/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

filename="$SCREENSHOT_DIR/$(date +%d-%m-%Y_%H:%M:%S).png"

# Take screenshot of selection
maim -s "$filename"

# Check if screenshot was successful
if [ $? -eq 0 ] && [ -f "$filename" ]; then
  # Copy to clipboard with xclip
  xclip -selection clipboard -t image/png -i "$filename"
  notify-send "Screenshot" "Saved and copied to clipboard" -i "$filename"
else
  notify-send "Screenshot" "Cancelled or failed"
fi
