#!/bin/bash
# rofi-pdf.sh - Simple PDF finder

# Starting directory (customize this)
START_DIR="$HOME/Documents"

# Find all PDFs and show only the filename
selected=$(find "$START_DIR" -type f -name "*.pdf" 2>/dev/null | \
    awk -F'/' '{print $NF}' | \
    sort | \
    rofi -dmenu -i -p "Open PDF")

if [ -n "$selected" ]; then
    # Find the full path of the selected file
    full_path=$(find "$START_DIR" -type f -name "$selected" 2>/dev/null | head -n 1)
    if [ -n "$full_path" ]; then
        xdg-open "$full_path" &
    fi
fi
