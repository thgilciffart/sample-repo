#!/bin/bash
# Volume control script using ponymix and dunstify
# Usage: ./volume.sh [up|down|mute]

# Get current volume and mute status
get_volume() {
    ponymix get-volume
}

get_mute_status() {
    ponymix is-muted && echo "muted" || echo "unmuted"
}

# Send notification with progress bar
notify_volume() {
    local volume=$(get_volume)
    local mute=$(get_mute_status)
    
    if [ "$mute" = "muted" ]; then
        dunstify -a "volume" -u normal -h string:x-dunst-stack-tag:volume \
                 -h int:value:0 "Volume: Muted" -t 2000
    else
        dunstify -a "volume" -u normal -h string:x-dunst-stack-tag:volume \
                 -h int:value:"$volume" "Volume: ${volume}%" -t 2000
    fi
}

# Main logic
case "$1" in
    up)
        ponymix increase 5
        notify_volume
        ;;
    down)
        ponymix decrease 5
        notify_volume
        ;;
    mute)
        ponymix toggle
        notify_volume
        ;;
    *)
        echo "Usage: $0 {up|down|mute}"
        exit 1
        ;;
esac