#!/bin/bash

SWITCH_CMD="export PATH=$PATH; $RELPATH/switch_style.sh"
STYLE_SCRIPT="export PATH=$PATH; $RELPATH/plugins/style/script.sh"

style_btn=(
	icon=􀎫
	icon.font="$FONT:Semibold:13.0"
	icon.color=$SELECT
	icon.padding_left=6
	icon.padding_right=6
	padding_left=2
	padding_right=2
	label.drawing=off
	script="$STYLE_SCRIPT"
	popup.align=right
	popup.y_offset=6
	popup.background.border_width=1
	popup.background.corner_radius=10
	popup.background.border_color=$POPUP_BORDER_COLOR
	popup.background.color=$POPUP_BACKGROUND_COLOR
	popup.blur_radius=25
	popup.background.shadow.drawing=on
)

sketchybar --add item style_switcher right \
	--set style_switcher "${style_btn[@]}" \
	--subscribe style_switcher mouse.clicked mouse.exited.global

add_popup_header() {
	local id="$1"
	local title="$2"
	sketchybar --add item "style.hdr.$id" popup.style_switcher \
		--set "style.hdr.$id" \
		icon.drawing=off \
		label="$title" \
		label.font="$FONT:Bold:10.0" \
		label.color=$SUBTLE \
		label.padding_left=10 \
		label.padding_right=10 \
		padding_left=4 \
		padding_right=4 \
		background.drawing=off
}

add_popup_option() {
	local id="$1"
	local title="$2"
	local is_active="$3"
	local click_cmd="$4"
	local custom_icon="${5:-}"

	local item_icon="􀀀"
	local item_icon_color="$MUTED"
	local item_label_color="$TEXT"
	local item_bg_drawing="off"

	if [[ "$is_active" == "true" ]]; then
		item_icon="􀁣"
		item_icon_color="$ACTIVE"
		item_label_color="$ACTIVE"
	fi

	if [[ -n "$custom_icon" ]]; then
		item_icon="$custom_icon"
		if [[ "$is_active" != "true" ]]; then
			item_icon_color="$SELECT"
		fi
	fi

	sketchybar --add item "style.opt.$id" popup.style_switcher \
		--set "style.opt.$id" \
		icon="$item_icon" \
		icon.font="$FONT:Semibold:12.0" \
		icon.color="$item_icon_color" \
		icon.padding_left=8 \
		icon.padding_right=6 \
		label="$title" \
		label.font="$FONT:Medium:12.0" \
		label.color="$item_label_color" \
		label.padding_right=12 \
		padding_left=4 \
		padding_right=4 \
		background.corner_radius=6 \
		background.height=24 \
		background.color="$HIGH_LOW" \
		background.drawing="$item_bg_drawing" \
		click_script="$click_cmd"
}

# --- Section: Layout / Design ---
add_popup_header "design" "DESIGN / LAYOUT"
add_popup_option "d_glass"   "Modern Glass Bar"      "$([[ "$BAR_DESIGN" == "glass" ]] && echo true || echo false)"   "$SWITCH_CMD --design glass"
add_popup_option "d_islands" "Floating Islands"      "$([[ "$BAR_DESIGN" == "islands" ]] && echo true || echo false)" "$SWITCH_CMD --design islands"
add_popup_option "d_minimal" "Minimal Flat"          "$([[ "$BAR_DESIGN" == "minimal" ]] && echo true || echo false)" "$SWITCH_CMD --design minimal"

# --- Section: Color Theme ---
add_popup_header "theme" "COLOR THEME"
add_popup_option "t_kana"  "Kanagawa Dragon"    "$([[ "$COLOR_SCHEME" == "kanagawa-dragon" ]] && echo true || echo false)"  "$SWITCH_CMD --theme kanagawa-dragon"
add_popup_option "t_glass" "macOS Native Glass" "$([[ "$COLOR_SCHEME" == "macos-glass" ]] && echo true || echo false)"      "$SWITCH_CMD --theme macos-glass"
add_popup_option "t_catp"  "Catppuccin Mocha"   "$([[ "$COLOR_SCHEME" == "catppuccin-mocha" ]] && echo true || echo false)" "$SWITCH_CMD --theme catppuccin-mocha"
add_popup_option "t_tokyo" "Tokyo Night"        "$([[ "$COLOR_SCHEME" == "tokyo-night" ]] && echo true || echo false)"      "$SWITCH_CMD --theme tokyo-night"
add_popup_option "t_rose"  "Rosé Pine Moon"     "$([[ "$COLOR_SCHEME" == "rosepine-moon" ]] && echo true || echo false)"    "$SWITCH_CMD --theme rosepine-moon"

# --- Section: Quick Options ---
add_popup_header "opts" "OPTIONEN & CONFIG"
add_popup_option "o_empty" "Leere Spaces ausblenden" "$([[ "$HIDE_EMPTY_SPACES" == "true" ]] && echo true || echo false)" "$SWITCH_CMD --toggle-empty"
add_popup_option "o_look"  "Kompakte Höhe (Compact)" "$([[ "$BAR_LOOK" == "compact" ]] && echo true || echo false)"       "$SWITCH_CMD --toggle-look"

# --- Section: Direct Config Access ---
add_popup_option "c_edit"    "Config öffnen (Editor)"        "false" "sketchybar --set style_switcher popup.drawing=off; $SWITCH_CMD --open-config auto"    "􀍟"
add_popup_option "c_nvim"    "Config in Ghostty + Neovim"    "false" "sketchybar --set style_switcher popup.drawing=off; $SWITCH_CMD --open-config nvim"    "􀩼"
add_popup_option "c_finder"  "Ordner im Finder öffnen"       "false" "sketchybar --set style_switcher popup.drawing=off; $SWITCH_CMD --open-config finder"  "􀈕"
add_popup_option "c_reload"  "SketchyBar neu laden"          "false" "$SWITCH_CMD --reload; sketchybar --reload"                                            "􀅈"

sendLog "Added style_switcher popup menu" "vomit"
