#!/bin/bash
# rofi-power.sh - Power/session management menu

# Menu options
show_menu() {
    echo "󰐥  Shutdown"
    echo "󰜉  Reboot"
    echo "󰤄  Suspend"
    echo "󰒲  Hibernate"
    echo "󰍃  Logout"
    echo "󰌾  Lock"
}

# Get selection
selected=$(show_menu | rofi -dmenu -i -p "Power Menu" -format "s")

# Confirmation dialog
confirm() {
    local action="$1"
    echo -e "Yes\nNo" | rofi -dmenu -i -p "Confirm $action?" -format "s"
}

if [ -z "$selected" ]; then
    exit 0
fi

# Handle selection
case "$selected" in
    "󰐥  Shutdown")
        if [ "$(confirm "shutdown")" = "Yes" ]; then
            systemctl poweroff
        fi
        ;;
    "󰜉  Reboot")
        if [ "$(confirm "reboot")" = "Yes" ]; then
            systemctl reboot
        fi
        ;;
    "󰤄  Suspend")
        systemctl suspend
        ;;
    "󰒲  Hibernate")
        systemctl hibernate
        ;;
    "󰍃  Logout")
        if [ "$(confirm "logout")" = "Yes" ]; then
            # Detect session type and logout accordingly
            if [ "$XDG_SESSION_DESKTOP" = "i3" ]; then
                i3-msg exit
            elif [ "$XDG_SESSION_DESKTOP" = "bspwm" ]; then
                bspc quit
            elif [ "$XDG_SESSION_DESKTOP" = "awesome" ]; then
                echo 'awesome.quit()' | awesome-client
            elif [ -n "$SWAYSOCK" ]; then
                swaymsg exit
            else
                # Generic logout
                loginctl terminate-user "$USER"
            fi
        fi
        ;;
    "󰌾  Lock")
        # Try common lock commands
        if command -v i3lock &> /dev/null; then
            i3lock -c 000000
        elif command -v swaylock &> /dev/null; then
            swaylock -c 000000
        elif command -v betterlockscreen &> /dev/null; then
            betterlockscreen -l
        elif command -v dm-tool &> /dev/null; then
            dm-tool lock
        else
            rofi -e "No lock command found"
        fi
        ;;
esac
