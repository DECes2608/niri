#!/bin/bash

if [ "$1" == "toggle" ]; then
    if warp-cli status | grep -q "Connected"; then
        warp-cli disconnect && notify-send "🛡️ Cloudflare WARP" "Bağlantı Kesildi"
    else
        warp-cli connect && notify-send "🛡️ Cloudflare WARP" "Güvenli Bağlantı Aktif"
    fi
    exit 0
fi

# Waybar için durum kontrolü
STATUS=$(warp-cli status)

if echo "$STATUS" | grep -q "Connected"; then
    echo '{"text": "🔒 WARP", "class": "connected", "tooltip": "Bağlantı Güvenli"}'
else
    echo '{"text": "🔓 WARP", "class": "disconnected", "tooltip": "Bağlantı Güvensiz"}'
fi
