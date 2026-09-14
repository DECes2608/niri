#!/usr/bin/env bash

# Font boyutunu (14pt) ve pencere genişliğini (%40) artırdık
cliphist list | rofi -dmenu -p "Pano" -theme-str 'element-text { font: "Monocraft 14"; } listview { lines: 10; } window { width: 40%; }' | cliphist decode | wl-copy
