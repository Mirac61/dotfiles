#!/bin/bash

## Scripts
SCRIPT_FRONT_APP="export PATH=$PATH; $RELPATH/plugins/frontapp/script.sh"

## Minimalist front app: monochrome icon + clean medium label
front_app=(
	background.drawing=off
	icon=􀢌
	icon.font="sketchybar-app-font:Regular:13.5"
	icon.color=$SUBTLE
	icon.padding_left=4
	icon.padding_right=4
	script="$SCRIPT_FRONT_APP"
	padding_left=2
	padding_right=6
	label.color=$TEXT
	label.font="$FONT:Medium:12.5"
	label.padding_left=2
	label.padding_right=6
	associated_display=active
)

sketchybar --add item front_app left \
	--set front_app "${front_app[@]}" \
	--subscribe front_app system_woke front_app_switched

"$RELPATH/plugins/frontapp/script.sh" &
