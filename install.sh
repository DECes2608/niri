#!/usr/bin/env bash
#
# niri dotfiles installer — Arch/Debian/Fedora/openSUSE tabanlı dağıtımlarda çalışır
# Kaynak: https://github.com/DECes2608/niri
#
# Kurallar:
#   - Sadece EN BAŞTA 2 şey sorar: (1) sudo şifresi, (2) [sadece Arch tabanlıysa]
#     hangi opsiyonel AUR paketlerinin kurulacağı. Ondan sonra hiçbir şey sormaz
#     (yay kendi içinde tekrar sudo isteyebilir, bu normaldir).
#   - AUR/yay SADECE Arch tabanlı bir dağıtım tespit edilirse devreye girer.
#   - Kaynaktan derlenmesi gereken AUR paketleri sadece küçük/hızlı derlenenlerdir;
#     büyük/uzun derlenenler (örn. ncspot) listede açıkça işaretlenmiştir.
#
# Kullanım: betiği reponun İÇİNE koy (fish/ mako/ niri/ nvim/ rofi/ scripts/ waybar/
# klasörleriyle aynı dizine) ve çalıştır:
#   chmod +x install.sh && ./install.sh
#
set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

c_ok()   { printf '\033[1;32m✔ %s\033[0m\n' "$1"; }
c_warn() { printf '\033[1;33m⚠ %s\033[0m\n' "$1"; }
c_err()  { printf '\033[1;31m✘ %s\033[0m\n' "$1"; }
c_info() { printf '\033[1;34mℹ %s\033[0m\n' "$1"; }

if [[ $EUID -eq 0 ]]; then
    c_err "Bu betiği root olarak çalıştırma; normal kullanıcı olarak çalıştır (gerektiğinde sudo kendisi soracak)."
    exit 1
fi

# ---------- 1) dağıtım tespiti ----------
PM=""
IS_ARCH=false
if [[ -r /etc/os-release ]]; then
    . /etc/os-release
else
    c_err "/etc/os-release bulunamadı, dağıtım tespit edilemedi."
    exit 1
fi

ID_ALL=" ${ID:-} ${ID_LIKE:-} "
case "$ID_ALL" in
    *" arch "*|*" manjaro "*|*" cachyos "*|*" endeavouros "*|*" garuda "*|*" artix "*)
        PM="pacman"; IS_ARCH=true ;;
    *" debian "*|*" ubuntu "*|*" pop "*|*" linuxmint "*|*" elementary "*)
        PM="apt" ;;
    *" fedora "*|*" rhel "*|*" centos "*)
        PM="dnf" ;;
    *" opensuse"*|*" suse "*)
        PM="zypper" ;;
    *)
        c_err "Desteklenmeyen dağıtım: ${PRETTY_NAME:-bilinmiyor}. pacman/apt/dnf/zypper dışında bir paket yöneticisi tespit edilemedi."
        exit 1 ;;
esac
c_info "Dağıtım: ${PRETTY_NAME:-$ID}  |  Paket yöneticisi: $PM  |  Arch tabanlı: $IS_ARCH"

# ---------- 2) SORU 1: sudo şifresi ----------
c_info "Paketleri kurmak için sudo şifreniz gerekiyor."
sudo -v || { c_err "sudo doğrulaması başarısız."; exit 1; }
( while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done ) &
SUDO_KEEPALIVE_PID=$!
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT

# ---------- 3) SORU 2 (sadece Arch tabanlıysa): opsiyonel AUR paketleri ----------
declare -a AUR_CHOSEN=()
if $IS_ARCH; then
    if ! command -v yay >/dev/null 2>&1; then
        c_info "yay bulunamadı; önceden derlenmiş 'yay-bin' kuruluyor (derleme yok)..."
        TMPDIR=$(mktemp -d)
        if git clone --depth 1 https://aur.archlinux.org/yay-bin.git "$TMPDIR/yay-bin" 2>/dev/null \
            && (cd "$TMPDIR/yay-bin" && makepkg -si --noconfirm); then
            c_ok "yay kuruldu"
        else
            c_warn "yay kurulamadı; AUR paketleri bu çalıştırmada atlanacak."
        fi
        rm -rf "$TMPDIR"
    fi

    if command -v yay >/dev/null 2>&1; then
        cat <<'EOF'

Aşağıdaki uygulamalar AUR üzerinden geliyor (resmi depolarda yok).
Kurmak istediklerinin numaralarını boşlukla ayırarak yaz (örn: 1 3 4),
hiçbirini istemiyorsan boş bırakıp Enter'a bas:

  1) helium-browser-bin      Helium tarayıcı        (hazır ikili, derleme YOK)
  2) cloudflare-warp-bin     Cloudflare WARP        (hazır ikili, derleme YOK)
  3) visual-studio-code-bin  VS Code                (hazır ikili, derleme YOK)
  4) awww                    duvar kağıdı daemonu   (küçük derleme, ~1-2 dk)
  5) mpvpaper                video duvar kağıdı      (küçük derleme, hızlı)

EOF
        read -rp "Seçim: " -a AUR_SEL
        declare -A AUR_MAP=(
            [1]=helium-browser-bin
            [2]=cloudflare-warp-bin
            [3]=visual-studio-code-bin
            [4]=awww
            [5]=mpvpaper
        )
        for n in "${AUR_SEL[@]-}"; do
            [[ -n "${AUR_MAP[$n]:-}" ]] && AUR_CHOSEN+=("${AUR_MAP[$n]}")
        done
    fi
fi

# ---------- 4) resmi depo paketleri ----------
c_info "Resmi depo paketleri kuruluyor (bu adımda başka soru sorulmaz)..."

case "$PM" in
    pacman)
        CORE_PKGS=(niri xwayland-satellite waybar mako rofi alacritty thunar
                   zathura zathura-pdf-poppler neovim fish playerctl wl-clipboard
                   cliphist blueman fcitx5 fcitx5-gtk
                   fcitx5-qt fcitx5-configtool gammastep hyprlock git base-devel
                   imagemagick mpv bluez bluez-utils ydotool wlr-randr) ;;
    apt)
        CORE_PKGS=(waybar mako-notifier rofi alacritty thunar zathura
                   zathura-pdf-poppler neovim fish playerctl wl-clipboard cliphist
                   blueman fcitx5 fcitx5-frontend-gtk3
                   fcitx5-frontend-qt5 gammastep hyprlock git imagemagick mpv
                   bluez ydotool wlr-randr) ;;
    dnf)
        CORE_PKGS=(niri xwayland-satellite waybar mako rofi alacritty thunar
                   zathura zathura-pdf-poppler neovim fish playerctl wl-clipboard
                   cliphist-applet blueman fcitx5 fcitx5-gtk3
                   fcitx5-qt gammastep hyprlock git ImageMagick mpv
                   bluez ydotool wlr-randr) ;;
    zypper)
        CORE_PKGS=(waybar mako rofi alacritty thunar zathura
                   zathura-plugin-pdf-poppler neovim fish playerctl wl-clipboard
                   cliphist blueman fcitx5 fcitx5-gtk3
                   fcitx5-qt5 gammastep hyprlock git ImageMagick mpv
                   bluez ydotool wlr-randr) ;;
esac

install_one() {
    local pkg="$1"
    case "$PM" in
        pacman) sudo pacman -S --needed --noconfirm "$pkg" ;;
        apt)    sudo apt-get install -y "$pkg" ;;
        dnf)    sudo dnf install -y "$pkg" ;;
        zypper) sudo zypper --non-interactive install "$pkg" ;;
    esac
}

case "$PM" in
    apt)    sudo apt-get update -y ;;
    zypper) sudo zypper --non-interactive refresh ;;
esac

FAILED_PKGS=()
for pkg in "${CORE_PKGS[@]}"; do
    if install_one "$pkg" >/tmp/"niri-install-${pkg}.log" 2>&1; then
        c_ok "$pkg"
    else
        c_warn "$pkg kurulamadı (bu dağıtımın resmi deposunda olmayabilir) — atlandı"
        FAILED_PKGS+=("$pkg")
    fi
done

# ---------- 5) seçilen AUR paketleri ----------
if $IS_ARCH && [[ ${#AUR_CHOSEN[@]} -gt 0 ]] && command -v yay >/dev/null 2>&1; then
    c_info "Seçilen AUR paketleri kuruluyor: ${AUR_CHOSEN[*]}"
    for pkg in "${AUR_CHOSEN[@]}"; do
        if yay -S --needed --noconfirm "$pkg"; then
            c_ok "$pkg (AUR)"
        else
            c_warn "$pkg (AUR) kurulamadı — atlandı"
        fi
    done
fi

# ---------- 6) dotfiles kopyalama ----------
c_info "Dotfiles ~/.config ve ~/.local/bin içine kopyalanıyor..."
mkdir -p ~/.config ~/.local/bin

copy_dir() {
    local src="$1" dest="$2"
    if [[ -d "$src" ]]; then
        mkdir -p "$dest"
        cp -rT "$src" "$dest"
        c_ok "$dest güncellendi"
    fi
}

copy_dir "$REPO_DIR/niri"   ~/.config/niri
copy_dir "$REPO_DIR/waybar" ~/.config/waybar
copy_dir "$REPO_DIR/mako"   ~/.config/mako
copy_dir "$REPO_DIR/rofi"   ~/.config/rofi
copy_dir "$REPO_DIR/nvim"   ~/.config/nvim
copy_dir "$REPO_DIR/fish"   ~/.config/fish

if [[ -d "$REPO_DIR/scripts" ]]; then
    cp -f "$REPO_DIR"/scripts/* ~/.local/bin/
    c_ok "scripts/ -> ~/.local/bin kopyalandı"
fi

chmod +x ~/.local/bin/* ~/.config/waybar/scripts/* ~/.config/rofi/scripts/* 2>/dev/null || true

# ---------- özet ----------
echo
c_info "Kurulum tamamlandı."
if [[ ${#FAILED_PKGS[@]} -gt 0 ]]; then
    c_warn "Resmi depoda bulunamayan/kurulamayan paketler: ${FAILED_PKGS[*]}"
    c_warn "Bunları elle kontrol etmen gerekebilir; paket adları dağıtımdan dağıtıma değişebiliyor."
fi
c_info "Not: wallpaper script'leri 'hakuspace-control/main_setting.sh', 'get_accent_color.py',"
c_info "'gen_style.sh', 'apply_style.sh' dosyalarına opsiyonel referans veriyor; bu repoda yoklar,"
c_info "yoksa sorunsuz atlanıyorlar."
c_info "ydotool için: sudo systemctl enable --now ydotool  &&  sudo usermod -aG input \$USER  (sonra yeniden giriş)"
echo
echo "Yeniden giriş yaptıktan sonra niri oturumunu başlatabilirsin (niri-session ya da ekran yöneticisi üzerinden)."
