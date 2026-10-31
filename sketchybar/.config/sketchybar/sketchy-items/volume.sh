#!/bin/bash

SCRIPT_VOLUME_CLICK="export PATH=$PATH; $RELPATH/plugins/volume/click.sh"
SCRIPT_VOLUME="export PATH=$PATH; $RELPATH/plugins/volume/script.sh"

volume_slider=(
	script="$SCRIPT_VOLUME"
	updates=on
	padding_left=0
	padding_right=0
	label.drawing=off
	icon.drawing=off
	slider.highlight_color=$TEXT
	slider.background.height=4
	slider.background.corner_radius=2
	slider.background.color=$MUTED
	slider.knob=􀀁
	slider.knob.drawing=off
)

volume_icon=(
	click_script="$SCRIPT_VOLUME_CLICK"
	icon.align=left
	icon.font="$FONT:Regular:13.5"
	icon.padding_left=5
	icon.padding_right=5
	padding_left=2
	padding_right=2
	icon.color=$TEXT
	label.drawing=off
)

sketchybar --add slider volume right \
	--set volume "${volume_slider[@]}" \
	--subscribe volume volume_change mouse.clicked mouse.entered mouse.exited \
	--add item volume_icon right \
	--set volume_icon "${volume_icon[@]}"
