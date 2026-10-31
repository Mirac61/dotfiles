#!/bin/bash

##
# SketchyBar Style, Theme & Config Manager
# Usage:
#   ./switch_style.sh                          # Interactive menu in terminal
#   ./switch_style.sh --theme <name>           # Set COLOR_SCHEME and reload
#   ./switch_style.sh --design <name>          # Set BAR_DESIGN and reload
#   ./switch_style.sh --look <compact|plain>   # Set BAR_LOOK and reload
#   ./switch_style.sh --toggle-empty           # Toggle HIDE_EMPTY_SPACES and reload
#   ./switch_style.sh --toggle-transparency    # Toggle BAR_TRANSPARENCY and reload
#   ./switch_style.sh --open-config [editor]   # Open config.sh (or sketchybar folder)
##

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SKETCHYBAR_CONFIG:-$DIR/config.sh}"

THEMES=("kanagawa-dragon" "macos-glass" "catppuccin-mocha" "tokyo-night" "rosepine-moon")
DESIGNS=("glass" "islands" "minimal")
LOOKS=("compact" "plain")

set_config_var() {
	local key="$1"
	local val="$2"
	local quoted="$3" # "true" if value should be quoted

	if [[ ! -f "$CONFIG_FILE" ]]; then
		touch "$CONFIG_FILE"
	fi

	local formatted_val="$val"
	if [[ "$quoted" == "true" ]]; then
		formatted_val="\"$val\""
	fi

	if grep -qE "^[[:space:]]*${key}=" "$CONFIG_FILE"; then
		sed -i '' -E "s|^[[:space:]]*${key}=.*|${key}=${formatted_val}|" "$CONFIG_FILE"
	else
		echo "${key}=${formatted_val}" >> "$CONFIG_FILE"
	fi
}

get_config_var() {
	local key="$1"
	local default_val="$2"
	if [[ -f "$CONFIG_FILE" ]]; then
		local val
		val=$(grep -E "^[[:space:]]*${key}=" "$CONFIG_FILE" | tail -n1 | cut -d'=' -f2- | sed -E 's/^[[:space:]]*"?//; s/"?[[:space:]]*$//')
		if [[ -n "$val" ]]; then
			echo "$val"
			return
		fi
	fi
	echo "$default_val"
}

open_config() {
	local target="${1:-auto}"
	case "$target" in
	"zed")
		if command -v zed >/dev/null 2>&1; then
			zed "$DIR" "$CONFIG_FILE"
		elif [[ -d "/Applications/Zed.app" ]]; then
			open -a "Zed" "$CONFIG_FILE"
		else
			open -t "$CONFIG_FILE"
		fi
		;;
	"nvim"|"ghostty")
		if [[ -d "/Applications/Ghostty.app" ]]; then
			open -na "Ghostty" --args -e nvim "$CONFIG_FILE"
		else
			open -t "$CONFIG_FILE"
		fi
		;;
	"finder")
		open "$DIR"
		;;
	*)
		if command -v zed >/dev/null 2>&1; then
			zed "$DIR" "$CONFIG_FILE"
		elif [[ -d "/Applications/Zed.app" ]]; then
			open -a "Zed" "$CONFIG_FILE"
		elif [[ -n "$EDITOR" ]] && [[ -t 1 ]]; then
			"$EDITOR" "$CONFIG_FILE"
		else
			open -t "$CONFIG_FILE"
		fi
		;;
	esac
}

reload_bar() {
	sketchybar --set logo popup.drawing=off 2>/dev/null || true
	sketchybar --reload
}

interactive_menu() {
	local cur_theme cur_design cur_look cur_empty
	cur_theme=$(get_config_var "COLOR_SCHEME" "kanagawa-dragon")
	cur_design=$(get_config_var "BAR_DESIGN" "glass")
	cur_look=$(get_config_var "BAR_LOOK" "compact")
	cur_empty=$(get_config_var "HIDE_EMPTY_SPACES" "true")

	echo "=========================================="
	echo "   SketchyBar Design & Theme Switcher"
	echo "=========================================="
	echo "Aktuell:"
	echo "  Theme            : $cur_theme"
	echo "  Design-Layout    : $cur_design"
	echo "  Größe (Look)     : $cur_look"
	echo "  Leere Spaces aus : $cur_empty"
	echo "------------------------------------------"
	echo "1) Theme wechseln (kanagawa-dragon, macos-glass, catppuccin-mocha, tokyo-night, rosepine-moon)"
	echo "2) Design wechseln (glass, islands, minimal)"
	echo "3) Bar-Größe wechseln (compact / plain)"
	echo "4) Leere Spaces ein-/ausblenden (aktuell: $cur_empty)"
	echo "5) config.sh im Editor öffnen"
	echo "6) SketchyBar neu laden"
	echo "q) Beenden"
	echo "------------------------------------------"
	read -rp "Auswahl: " choice

	case "$choice" in
	1)
		echo ""
		echo "Verfügbare Themes:"
		local i=1
		for t in "${THEMES[@]}"; do
			echo "  $i) $t"
			((i++))
		done
		read -rp "Theme-Nummer (1-${#THEMES[@]}): " t_idx
		if [[ "$t_idx" =~ ^[1-9][0-9]*$ ]] && (( t_idx >= 1 && t_idx <= ${#THEMES[@]} )); then
			local chosen="${THEMES[$((t_idx - 1))]}"
			set_config_var "COLOR_SCHEME" "$chosen" "true"
			echo "-> Theme auf '$chosen' gesetzt. Lade SketchyBar neu..."
			reload_bar
		fi
		;;
	2)
		echo ""
		echo "Verfügbare Designs:"
		echo "  1) glass   (Modern Glass Bar - durchgehende Milchglas-Leiste mit Kapseln)"
		echo "  2) islands (Floating Islands - frei schwebende Einzel-Pills ohne Balken)"
		echo "  3) minimal (Minimal Flat - schlanke, flache Leiste ohne Kästchen-Rahmen)"
		read -rp "Design-Nummer (1-3): " d_idx
		if [[ "$d_idx" =~ ^[1-3]$ ]]; then
			local chosen="${DESIGNS[$((d_idx - 1))]}"
			set_config_var "BAR_DESIGN" "$chosen" "true"
			echo "-> Design auf '$chosen' gesetzt. Lade SketchyBar neu..."
			reload_bar
		fi
		;;
	3)
		local next_look="plain"
		[[ "$cur_look" == "plain" ]] && next_look="compact"
		set_config_var "BAR_LOOK" "$next_look" "true"
		echo "-> Größe auf '$next_look' gesetzt. Lade SketchyBar neu..."
		reload_bar
		;;
	4)
		local next_empty="true"
		[[ "$(echo "$cur_empty" | tr '[:upper:]' '[:lower:]')" == "true" ]] && next_empty="false"
		set_config_var "HIDE_EMPTY_SPACES" "$next_empty" "false"
		echo "-> HIDE_EMPTY_SPACES auf '$next_empty' gesetzt. Lade SketchyBar neu..."
		reload_bar
		;;
	5)
		open_config "auto"
		;;
	6)
		reload_bar
		;;
	*)
		exit 0
		;;
	esac
}

if [[ $# -eq 0 ]]; then
	interactive_menu
	exit 0
fi

DO_RELOAD=false

while [[ $# -gt 0 ]]; do
	case "$1" in
	--theme|-t)
		set_config_var "COLOR_SCHEME" "$2" "true"
		DO_RELOAD=true
		shift 2
		;;
	--design|-d)
		set_config_var "BAR_DESIGN" "$2" "true"
		DO_RELOAD=true
		shift 2
		;;
	--look|-l)
		set_config_var "BAR_LOOK" "$2" "true"
		DO_RELOAD=true
		shift 2
		;;
	--toggle-empty)
		cur=$(get_config_var "HIDE_EMPTY_SPACES" "true")
		if [[ "$(echo "$cur" | tr '[:upper:]' '[:lower:]')" == "true" ]]; then
			set_config_var "HIDE_EMPTY_SPACES" "false" "false"
		else
			set_config_var "HIDE_EMPTY_SPACES" "true" "false"
		fi
		DO_RELOAD=true
		shift
		;;
	--toggle-look)
		cur=$(get_config_var "BAR_LOOK" "compact")
		if [[ "$cur" == "compact" ]]; then
			set_config_var "BAR_LOOK" "plain" "true"
		else
			set_config_var "BAR_LOOK" "compact" "true"
		fi
		DO_RELOAD=true
		shift
		;;
	--toggle-transparency)
		cur=$(get_config_var "BAR_TRANSPARENCY" "true")
		if [[ "$(echo "$cur" | tr '[:upper:]' '[:lower:]')" == "true" ]]; then
			set_config_var "BAR_TRANSPARENCY" "false" "false"
		else
			set_config_var "BAR_TRANSPARENCY" "true" "false"
		fi
		DO_RELOAD=true
		shift
		;;
	--open-config|config|open)
		editor_arg="${2:-auto}"
		open_config "$editor_arg"
		exit 0
		;;
	*)
		# Shorthand support: ./switch_style.sh kanagawa-dragon islands
		for t in "${THEMES[@]}"; do
			if [[ "$1" == "$t" ]]; then
				set_config_var "COLOR_SCHEME" "$1" "true"
				DO_RELOAD=true
			fi
		done
		for d in "${DESIGNS[@]}"; do
			if [[ "$1" == "$d" ]]; then
				set_config_var "BAR_DESIGN" "$1" "true"
				DO_RELOAD=true
			fi
		done
		shift
		;;
	esac
done

if [[ "$DO_RELOAD" == "true" ]]; then
	reload_bar
fi
