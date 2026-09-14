# System & Environment Overview

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/a430a7c6-5db3-4cbe-a31a-b1dac83364c7" />

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

## Installation

Clone the repo and run the installer — it detects your distro (Arch/Debian/Fedora/openSUSE),
installs the required packages, and copies the dotfiles into place:

```bash
git clone https://github.com/DECes2608/niri.git
cd niri
chmod +x install.sh && ./install.sh
```

---

## Execution Permissions

For manual/partial setups, make all scripts executable with a single command:

```bash
chmod +x ~/.local/bin/* ~/.config/waybar/scripts/* ~/.config/rofi/scripts/*
