#!/bin/bash

SCRIPT_MIC="export PATH=$PATH; $RELPATH/plugins/mic/script.sh"

mic=(
	icon=􀊱
	icon.font="$FONT:Regular:13.5"
	icon.color=$TEXT
	icon.padding_left=5
	icon.padding_right=5
	padding_left=2
	padding_right=2
	label.drawing=off
	script="$SCRIPT_MIC"
)

sketchybar --add item mic right \
	--set mic "${mic[@]}" \
	--subscribe mic mouse.clicked
