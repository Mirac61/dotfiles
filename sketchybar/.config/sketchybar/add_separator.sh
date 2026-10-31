#!/bin/bash

## Minimalist separator: clean breathing space without visual dot clutter
add_separator() {
	local sep_id="$1"
	local sep_pos="$2"

	separator=(
		icon.drawing=off
		label.drawing=off
		padding_left=2
		padding_right=2
		background.drawing=off
	)

	sketchybar --add item "separator.$sep_id" "$sep_pos" \
		--set "separator.$sep_id" "${separator[@]}"
}
