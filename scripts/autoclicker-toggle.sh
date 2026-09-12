#!/usr/bin/env bash

PIDFILE="/tmp/autoclicker.pid"
INTERVAL=0.05 # tıklamalar arası saniye, istediğin gibi ayarla

if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  kill "$(cat "$PIDFILE")"
  rm -f "$PIDFILE"
  notify-send "Autoclicker" "Durduruldu"
else
  (
    while true; do
      ydotool click 0xC0
      sleep "$INTERVAL"
    done
  ) &
  echo $! >"$PIDFILE"
  notify-send "Autoclicker" "Başladı"
fi
