# System & Environment Overview

![Desktop Setup](<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/31ae2adb-c07e-43c8-8f10-54f443d8cedf" />
)

## Core Applications

| Category | Application |
| :--- | :--- |
| **Browser** | Helium |
| **File Manager** | Thunar |
| **Document Viewer** | Zathura |
| **Terminal** | Alacritty |
| **App Launcher & Clipboard** | Rofi |
| **Text Editor** | Neovim / Vim |
| **Code Editor** | VS Code (`code`) |
| **Status Bar** | Waybar |
| **Distribution** | Arch Linux |

---

## Custom Scripts

* `~/.local/bin/`
  * `autoclicker-toggle.sh`
  * `kitap-select.sh`
  * `wallpaper-select.sh`
  * `wallpaper-set.sh`
  * `nightlight-toggle.sh`
  * `warp-toggle.sh`

* `~/.config/waybar/scripts/`
  * `ncspot_event.sh`
  * `ncspot_poll.sh`
  * `toggle_music_workspace.sh`
  * `warp_toggle.sh`

* `~/.config/rofi/scripts/`
  * `config.sh`
  * `powermenu.sh`
  * `clipboard.sh`
  * `clip-clear.sh`

---

## Execution Permissions

Make all scripts executable with a single command:

```bash
chmod +x ~/.local/bin/* ~/.config/waybar/scripts/* ~/.config/rofi/scripts/*
