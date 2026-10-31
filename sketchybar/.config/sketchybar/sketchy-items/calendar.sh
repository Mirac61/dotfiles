#!/bin/bash

SCRIPT_CALENDAR="export PATH=$PATH; $RELPATH/plugins/calendar/script.sh"
HOVER_SCRIPT="export PATH=$PATH; $RELPATH/plugins/popup_hover.sh"

calendar=(
	icon="$(date '+%a %d. %b')"
	label="$(date '+%H:%M')"
	icon.font="$FONT:Medium:12.0"
	icon.color=$SUBTLE
	icon.padding_left=6
	icon.padding_right=4
	label.font="$FONT:Semibold:12.0"
	label.color=$TEXT
	label.padding_left=2
	label.padding_right=6
	padding_left=2
	padding_right=4
	background.drawing=off
	update_freq=30
	script="$SCRIPT_CALENDAR"
	click_script="sketchybar --set logo popup.drawing=off --set wifi popup.drawing=off --set battery popup.drawing=off --set calendar popup.drawing=toggle"
	popup.align=right
	popup.y_offset=6
	popup.background.border_width=1
	popup.background.corner_radius=10
	popup.background.border_color=$POPUP_BORDER_COLOR
	popup.background.color=$POPUP_BACKGROUND_COLOR
	popup.blur_radius=25
	popup.background.shadow.drawing=on
)

popup_btn=(
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

sketchybar --add item calendar right \
	--set calendar "${calendar[@]}" \
	--subscribe calendar system_woke mouse.exited.global \
	--add item calendar.header popup.calendar \
	--set calendar.header \
		icon=􀉉 \
		icon.font="$FONT:Semibold:12.5" \
		icon.color=$TEXT \
		icon.padding_left=12 \
		icon.padding_right=6 \
		label="$(date '+%A, %d. %B')" \
		label.font="$FONT:Semibold:12.5" \
		label.color=$TEXT \
		label.padding_right=14 \
		background.height=24 \
		background.drawing=off \
	--add item calendar.sub popup.calendar \
	--set calendar.sub \
		icon.drawing=off \
		label="$(date '+Kalenderwoche %V  •  %Y')" \
		label.font="$FONT:Medium:11.0" \
		label.color=$SUBTLE \
		label.padding_left=12 \
		label.padding_right=14 \
		background.height=18 \
		background.drawing=off \
	--add item calendar.open popup.calendar \
	--set calendar.open "${popup_btn[@]}" \
		icon=􀄔 \
		label="Kalender öffnen…" \
		click_script="sketchybar --set calendar popup.drawing=off; open -a Calendar" \
	--subscribe calendar.open mouse.entered mouse.exited \
	--add item calendar.copy popup.calendar \
	--set calendar.copy "${popup_btn[@]}" \
		icon=􀆪 \
		label="Datum kopieren ($(date '+%Y-%m-%d'))" \
		click_script="date '+%Y-%m-%d' | tr -d '\n' | pbcopy; sketchybar --set calendar popup.drawing=off" \
	--subscribe calendar.copy mouse.entered mouse.exited
