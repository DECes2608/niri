#!/bin/bash

# ncspot'tan çalma durumunu ve şarkı bilgilerini alıyoruz
STATE="$NCSPOT_STATE"    # "Playing" veya "Paused" döner
TITLE="$NCSPOT_TITLE"
ARTIST="$NCSPOT_ARTIST"

# Duruma göre ikon ve CSS class belirle
if [ "$STATE" = "Playing" ]; then
    ICON="▶"
    CLASS="playing"
elif [ "$STATE" = "Paused" ]; then
    ICON="⏸"
    CLASS="paused"
else
    ICON="■"
    CLASS="stopped"
fi

# Şarkı adını kısalt (dikey bar için max 8 karakter)
SHORT_TITLE=$(echo "$TITLE" | cut -c 1-8)

# Tooltip'e tam bilgiyi koy
TOOLTIP="$ARTIST — $TITLE [$STATE]"

# JSON çıktısı: text=ikon + kısa ad, tooltip=tam bilgi, class=durum
printf '{"text": "%s %s", "tooltip": "%s", "class": "%s"}\n' \
    "$ICON" "$SHORT_TITLE" "$TOOLTIP" "$CLASS" \
    > /tmp/current_song.json

# Waybar'a RTMIN+5 sinyali gönder (config'deki "signal": 5 ile eşleşir)
pkill -RTMIN+5 waybar
