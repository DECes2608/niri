#!/bin/bash

STATE=$(playerctl -p ncspot status 2>/dev/null)

if [ -z "$STATE" ]; then
    printf '{"text": "■  ncspot kapalı", "tooltip": "", "class": "offline"}\n'
    exit 0
fi

TITLE=$(playerctl -p ncspot metadata title 2>/dev/null)
ARTIST=$(playerctl -p ncspot metadata artist 2>/dev/null)

if [ "$STATE" = "Playing" ]; then
    ICON="▶"
    CLASS="playing"
else
    ICON="⏸"
    CLASS="paused"
fi

# Yatay barda tam şarkı adı sığar, max 35 karakter
SHORT_TITLE=$(echo "$TITLE" | cut -c 1-35)

TOOLTIP="$ARTIST — $TITLE"

printf '{"text": "%s  %s", "tooltip": "%s", "class": "%s"}\n' \
    "$ICON" "$SHORT_TITLE" "$TOOLTIP" "$CLASS"
