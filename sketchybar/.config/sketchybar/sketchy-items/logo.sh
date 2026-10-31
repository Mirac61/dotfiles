#!/bin/bash

SWITCH_CMD="export PATH=$PATH; $RELPATH/switch_style.sh"
SCRIPT_LOGO_POPUP="export PATH=$PATH; $RELPATH/plugins/logo/script.sh"
HOVER_SCRIPT="export PATH=$PATH; $RELPATH/plugins/popup_hover.sh"

case "$COLOR_SCHEME" in
"kanagawa-dragon") THEME_LABEL="Kanagawa" ;;
"macos-glass")     THEME_LABEL="macOS Glass" ;;
"catppuccin-mocha") THEME_LABEL="Catppuccin" ;;
"tokyo-night")     THEME_LABEL="Tokyo Night" ;;
"rosepine-moon")   THEME_LABEL="Rosé Pine" ;;
*)                 THEME_LABEL="$COLOR_SCHEME" ;;
esac

case "$BAR_DESIGN" in
"islands"|"transparent") DESIGN_LABEL="Minimal Tint" ;;
"glass")                 DESIGN_LABEL="Floating Glass" ;;
"capsules")              DESIGN_LABEL="Split Capsules" ;;
*)                       DESIGN_LABEL="Flat Bar" ;;
esac

logo=(
	icon=􀆔
	padding_left=6
	padding_right=4
	icon.font="$FONT:Medium:13.5"
	icon.color=$TEXT
	icon.padding_left=6
	icon.padding_right=6
	script="$SCRIPT_LOGO_POPUP"
	label.drawing=off
	background.drawing=off
	popup.align=left
	popup.y_offset=6
	popup.background.border_width=1
	popup.background.corner_radius=10
	popup.background.border_color=$POPUP_BORDER_COLOR
	popup.background.color=$POPUP_BACKGROUND_COLOR
	popup.blur_radius=25
	popup.background.shadow.drawing=on
)

sketchybar --add item logo left \
	--set logo "${logo[@]}" \
	--subscribe logo mouse.clicked mouse.exited.global

add_main_row() {
	local id="$1"
	local row_icon="$2"
	local title="$3"
	local click_cmd="$4"
	local icon_col="${5:-$SUBTLE}"

	sketchybar --add item "logo.row.$id" popup.logo \
		--set "logo.row.$id" \
		icon="$row_icon" \
		icon.font="$FONT:Medium:11.5" \
		icon.color="$icon_col" \
		icon.padding_left=10 \
		icon.padding_right=6 \
		label="$title" \
		label.font="$FONT:Medium:12.0" \
		label.color="$TEXT" \
		label.padding_right=12 \
		padding_left=4 \
		padding_right=4 \
		background.corner_radius=6 \
		background.height=22 \
		background.color="$HIGH_MED" \
		background.drawing=off \
		script="$HOVER_SCRIPT" \
		click_script="$click_cmd" \
		--subscribe "logo.row.$id" mouse.entered mouse.exited
}

add_sub_option() {
	local group="$1"
	local id="$2"
	local title="$3"
	local is_active="$4"
	local click_cmd="$5"

	local item_icon="·"
	local item_color="$SUBTLE"
	if [[ "$is_active" == "true" ]]; then
		item_icon="􀆅"
		item_color="$TEXT"
	fi

	sketchybar --add item "logo.sub.${group}.${id}" popup.logo \
		--set "logo.sub.${group}.${id}" \
		drawing=off \
		icon="$item_icon" \
		icon.font="$FONT:Bold:10.5" \
		icon.color="$item_color" \
		icon.padding_left=20 \
		icon.padding_right=6 \
		label="$title" \
		label.font="$FONT:Regular:11.5" \
		label.color="$item_color" \
		label.padding_right=12 \
		padding_left=4 \
		padding_right=4 \
		background.corner_radius=6 \
		background.height=20 \
		background.color="$HIGH_MED" \
		background.drawing=off \
		script="$HOVER_SCRIPT" \
		click_script="$click_cmd" \
		--subscribe "logo.sub.${group}.${id}" mouse.entered mouse.exited
}

# 1. Expandable Theme Selector
TOGGLE_THEMES="STATE=\$(sketchybar --query logo.sub.theme.kana | jq -r '.geometry.drawing'); if [ \"\$STATE\" = 'on' ]; then sketchybar --set '/logo.sub.theme.*/' drawing=off; else sketchybar --set '/logo.sub.design.*/' drawing=off --set '/logo.sub.theme.*/' drawing=on; fi"
add_main_row "theme" "􀎫" "Theme · $THEME_LABEL" "$TOGGLE_THEMES"
add_sub_option "theme" "kana"  "Kanagawa Dragon"  "$([[ "$COLOR_SCHEME" == "kanagawa-dragon" ]] && echo true || echo false)"  "$SWITCH_CMD --theme kanagawa-dragon"
add_sub_option "theme" "glass" "macOS Glass"      "$([[ "$COLOR_SCHEME" == "macos-glass" ]] && echo true || echo false)"      "$SWITCH_CMD --theme macos-glass"
add_sub_option "theme" "catp"  "Catppuccin Mocha" "$([[ "$COLOR_SCHEME" == "catppuccin-mocha" ]] && echo true || echo false)" "$SWITCH_CMD --theme catppuccin-mocha"
add_sub_option "theme" "tokyo" "Tokyo Night"      "$([[ "$COLOR_SCHEME" == "tokyo-night" ]] && echo true || echo false)"      "$SWITCH_CMD --theme tokyo-night"
add_sub_option "theme" "rose"  "Rosé Pine Moon"   "$([[ "$COLOR_SCHEME" == "rosepine-moon" ]] && echo true || echo false)"    "$SWITCH_CMD --theme rosepine-moon"

# 2. Expandable Style Selector
TOGGLE_DESIGNS="STATE=\$(sketchybar --query logo.sub.design.islands | jq -r '.geometry.drawing'); if [ \"\$STATE\" = 'on' ]; then sketchybar --set '/logo.sub.design.*/' drawing=off; else sketchybar --set '/logo.sub.theme.*/' drawing=off --set '/logo.sub.design.*/' drawing=on; fi"
add_main_row "design" "􀏜" "Stil · $DESIGN_LABEL" "$TOGGLE_DESIGNS"
add_sub_option "design" "islands"  "Minimal Tint"   "$([[ "$BAR_DESIGN" == "islands" || "$BAR_DESIGN" == "transparent" ]] && echo true || echo false)" "$SWITCH_CMD --design islands"
add_sub_option "design" "glass"    "Floating Glass" "$([[ "$BAR_DESIGN" == "glass" ]] && echo true || echo false)"                                     "$SWITCH_CMD --design glass"
add_sub_option "design" "capsules" "Split Capsules" "$([[ "$BAR_DESIGN" == "capsules" ]] && echo true || echo false)"                                  "$SWITCH_CMD --design capsules"

# 3. Empty Spaces Toggle
EMPTY_ICON="􀀀"
EMPTY_COL="$MUTED"
if [[ "$HIDE_EMPTY_SPACES" == "true" ]]; then
	EMPTY_ICON="􀁣"
	EMPTY_COL="$TEXT"
fi
add_main_row "empty" "$EMPTY_ICON" "Leere Spaces ausblenden" "$SWITCH_CMD --toggle-empty" "$EMPTY_COL"

# 4. Open Config
add_main_row "config" "􀩼" "Config öffnen…" "sketchybar --set logo popup.drawing=off; $SWITCH_CMD --open-config nvim"

# 5. Reload Bar
add_main_row "reload" "􀅈" "Neu laden" "$SWITCH_CMD --reload; sketchybar --reload"
