#!/bin/bash

SCRIPT_CLICK_BATTERY="export PATH=$PATH; $RELPATH/plugins/battery/click.sh"
SCRIPT_BATTERY="export PATH=$PATH; $RELPATH/plugins/battery/script.sh"
HOVER_SCRIPT="export PATH=$PATH; $RELPATH/plugins/popup_hover.sh"

battery=(
	drawing=off
	script="$SCRIPT_BATTERY"
	click_script="$SCRIPT_CLICK_BATTERY"
	icon.font="$FONT:Regular:14.0"
	icon.color=$TEXT
	icon.padding_left=5
	icon.padding_right=2
	label=""
	label.font="$FONT:Medium:11.5"
	label.color=$TEXT
	label.padding_left=2
	label.padding_right=5
	padding_left=2
	padding_right=2
	update_freq=60
	updates=on
	popup.align=right
	popup.y_offset=6
	popup.background.border_width=1
	popup.background.corner_radius=10
	popup.background.border_color=$POPUP_BORDER_COLOR
	popup.background.color=$POPUP_BACKGROUND_COLOR
	popup.blur_radius=25
	popup.background.shadow.drawing=on
)

popup_batt_row=(
	icon.font="$FONT:Medium:11.5"
	icon.color=$SUBTLE
	icon.padding_left=10
	icon.padding_right=6
	label.font="$FONT:Medium:12.0"
	label.color=$TEXT
	label.padding_right=14
	padding_left=4
	padding_right=4
	background.corner_radius=6
	background.height=24
	background.color=$HIGH_MED
	background.drawing=off
	script="$HOVER_SCRIPT"
)

sketchybar --add item battery right \
	--set battery "${battery[@]}" \
	--subscribe battery power_source_change system_woke mouse.exited.global \
	--add item battery.status popup.battery \
	--set battery.status \
		icon=􀛨 \
		icon.font="$FONT:Semibold:12.0" \
		icon.color=$TEXT \
		icon.padding_left=12 \
		icon.padding_right=6 \
		label="Batterie" \
		label.font="$FONT:Semibold:12.0" \
		label.color=$TEXT \
		label.padding_right=14 \
		background.height=22 \
		background.drawing=off \
	--add item battery.time popup.battery \
	--set battery.time \
		icon.drawing=off \
		label="Berechne…" \
		label.font="$FONT:Medium:11.0" \
		label.color=$SUBTLE \
		label.padding_left=12 \
		label.padding_right=14 \
		background.height=18 \
		background.drawing=off \
	--add item battery.settings popup.battery \
	--set battery.settings "${popup_batt_row[@]}" \
		icon=􀍟 \
		label="Batterie-Einstellungen…" \
		click_script="sketchybar --set battery popup.drawing=off; open 'x-apple.systempreferences:com.apple.Battery-Settings.extension'" \
	--subscribe battery.settings mouse.entered mouse.exited
