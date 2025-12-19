#!/bin/bash
# rofi-theme.sh - Simple theme switcher

# Directory containing your theme scripts
THEME_DIR="$HOME/.config/rofi/themes"

# List all .sh files and strip the extension
selected=$(find "$THEME_DIR" -maxdepth 1 -type f -name "*.sh" 2>/dev/null | \
    awk -F'/' '{print $NF}' | \
    sed 's/.sh$//' | \
    sort | \
    rofi -dmenu -i -p "Select Theme")

if [ -n "$selected" ]; then
    # Execute the selected theme script
    "$THEME_DIR/${selected}.sh"
fi
