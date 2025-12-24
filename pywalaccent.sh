#!/bin/bash

LOG_FILE="$HOME/.local/pywalaccent/pywalaccent.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

update_colors() {
    now=$(gsettings get org.gnome.desktop.background picture-uri)
    temp="${now#"'file://"}"
    wallpaper="${temp%"'"}"
    
    if [ -f "$wallpaper" ]; then
        log "Wallpaper changed to: $wallpaper"
        
        if wal_output=$(wal -i "$wallpaper" -q 2>&1); then
            log "Colors updated successfully"
        else
            log "ERROR: wal failed to process wallpaper"
            log "wal output: $wal_output"
            log "Wallpaper format may be unsupported or file may be corrupted"
        fi
    else
        log "ERROR: Wallpaper file not found: $wallpaper"
    fi
}

log "Starting pywalaccent"

update_colors

dconf watch /org/gnome/desktop/background/picture-uri | while read -r; do
    update_colors
done
