#!/usr/bin/env bash

# Rofi ile onay sor
CONFIRM=$(echo -e "Evet\nHayır" | rofi -dmenu -p "Pano geçmişi silinsin mi?" -theme-str 'element-text { font: "Monocraft 14"; } window { width: 25%; }')

if [ "$CONFIRM" = "Evet" ]; then
  cliphist wipe
  notify-send "Pano" "Pano geçmişi temizlendi."
fi
