#!/usr/bin/env bash
set -euo pipefail

##
# Miracs Dotfiles Installer
# Modules: nvim, tmux, zellij, aerospace, sketchybar
#
# Usage:
#   ./install.sh               # Interactive installation (Homebrew + Symlinks)
#   ./install.sh --all         # Unattended full setup (Homebrew + Symlinks)
#   ./install.sh --link-only   # Only create backups & symlinks
#   ./install.sh nvim zellij   # Only link specific modules
##

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date '+%Y%m%d_%H%M%S')"
ALL_MODULES=("nvim" "tmux" "zellij" "aerospace" "sketchybar")

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { printf "${BLUE}[INFO]${NC} %s\n" "$1"; }
ok()    { printf "${GREEN}[OK]${NC}   %s\n" "$1"; }
warn()  { printf "${YELLOW}[WARN]${NC} %s\n" "$1"; }
err()   { printf "${RED}[ERR]${NC}  %s\n" "$1"; }

backup_if_needed() {
	local target="$1"
	# If it's a real file/dir (not a symlink), move it to backup
	if [[ -e "$target" && ! -L "$target" ]]; then
		mkdir -p "$BACKUP_DIR"
		local name
		name="$(basename "$target")"
		warn "Sichere bestehende Konfiguration: $target -> $BACKUP_DIR/$name"
		mv "$target" "$BACKUP_DIR/$name"
	elif [[ -L "$target" ]]; then
		rm -f "$target"
	fi
}

link_item() {
	local src="$1"
	local dest="$2"
	mkdir -p "$(dirname "$dest")"
	backup_if_needed "$dest"
	ln -sfn "$src" "$dest"
	ok "Verlinkt: $dest -> $src"
}

link_module() {
	local mod="$1"
	case "$mod" in
	"nvim")
		link_item "$DOTFILES_DIR/nvim/.config/nvim" "$HOME/.config/nvim"
		;;
	"tmux")
		mkdir -p "$HOME/.config/tmux"
		link_item "$DOTFILES_DIR/tmux/.config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
		if [[ -f "$DOTFILES_DIR/tmux/.config/tmux/switch-theme.sh" ]]; then
			link_item "$DOTFILES_DIR/tmux/.config/tmux/switch-theme.sh" "$HOME/.config/tmux/switch-theme.sh"
		fi
		;;
	"zellij")
		link_item "$DOTFILES_DIR/zellij/.config/zellij" "$HOME/.config/zellij"
		;;
	"aerospace")
		link_item "$DOTFILES_DIR/aerospace/.aerospace.toml" "$HOME/.aerospace.toml"
		;;
	"sketchybar")
		link_item "$DOTFILES_DIR/sketchybar/.config/sketchybar" "$HOME/.config/sketchybar"
		;;
	*)
		err "Unbekanntes Modul: $mod"
		;;
	esac
}

install_homebrew_deps() {
	if ! command -v brew >/dev/null 2>&1; then
		warn "Homebrew ist nicht installiert. Überspringe Paket-Installation."
		return
	fi

	info "Installiere / prüfe Homebrew-Pakete..."
	brew tap FelixKratz/formulae 2>/dev/null || true
	brew tap nikitabobko/tap 2>/dev/null || true

	local formulae=("neovim" "tmux" "zellij" "stow" "jq" "ripgrep" "fd" "lazygit" "git-delta" "sketchybar")
	for pkg in "${formulae[@]}"; do
		if brew list --formula "$pkg" >/dev/null 2>&1; then
			ok "Bereits installiert: $pkg"
		else
			info "Installiere $pkg..."
			brew install "$pkg" || warn "Konnte $pkg nicht installieren"
		fi
	done

	local casks=("aerospace" "font-sf-pro" "font-sf-mono" "sf-symbols" "font-sketchybar-app-font")
	for cask in "${casks[@]}"; do
		if brew list --cask "$cask" >/dev/null 2>&1; then
			ok "Bereits installiert (Cask): $cask"
		else
			info "Installiere Cask $cask..."
			brew install --cask "$cask" || warn "Konnte Cask $cask nicht installieren"
		fi
	done
}

post_install_hooks() {
	# Ensure ~/dotfiles convenience symlink exists if repo is in ~/code/personal/dotfiles
	if [[ "$DOTFILES_DIR" != "$HOME/dotfiles" && ! -e "$HOME/dotfiles" ]]; then
		ln -sfn "$DOTFILES_DIR" "$HOME/dotfiles"
		ok "Convenience-Symlink angelegt: ~/dotfiles -> $DOTFILES_DIR"
	fi

	# Reload SketchyBar if running
	if pgrep -x sketchybar >/dev/null 2>&1; then
		info "Lade SketchyBar neu..."
		sketchybar --reload || true
	fi

	# Reload AeroSpace if running
	if pgrep -x AeroSpace >/dev/null 2>&1 && command -v aerospace >/dev/null 2>&1; then
		info "Lade AeroSpace-Konfiguration neu..."
		aerospace reload-config 2>/dev/null || true
	fi
}

MODE="interactive"
SELECTED_MODULES=()

while [[ $# -gt 0 ]]; do
	case "$1" in
	--all|-a)
		MODE="all"
		shift
		;;
	--link-only|-l)
		MODE="link-only"
		shift
		;;
	--help|-h)
		echo "Verwendung: ./install.sh [--all | --link-only | <module...>]"
		echo "Verfügbare Module: ${ALL_MODULES[*]}"
		exit 0
		;;
	*)
		MODE="custom"
		SELECTED_MODULES+=("$1")
		shift
		;;
	esac
done

echo "=================================================="
echo "   Miracs Dotfiles Installer"
echo "   Quelle: $DOTFILES_DIR"
echo "=================================================="

if [[ "$MODE" == "all" ]]; then
	install_homebrew_deps
	for m in "${ALL_MODULES[@]}"; do
		link_module "$m"
	done
	post_install_hooks
elif [[ "$MODE" == "link-only" ]]; then
	for m in "${ALL_MODULES[@]}"; do
		link_module "$m"
	done
	post_install_hooks
elif [[ "$MODE" == "custom" ]]; then
	for m in "${SELECTED_MODULES[@]}"; do
		link_module "$m"
	done
	post_install_hooks
else
	read -rp "Möchtest du fehlende Homebrew-Pakete prüfen/installieren? [j/N]: " brew_ans
	if [[ "$brew_ans" =~ ^[jJyY]$ ]]; then
		install_homebrew_deps
	fi

	echo ""
	info "Verlinke Konfigurations-Module (${ALL_MODULES[*]})..."
	for m in "${ALL_MODULES[@]}"; do
		link_module "$m"
	done
	post_install_hooks
fi

echo ""
ok "Installation abgeschlossen!"
if [[ -d "$BACKUP_DIR" ]]; then
	info "Backups vorheriger Dateien liegen unter: $BACKUP_DIR"
fi
