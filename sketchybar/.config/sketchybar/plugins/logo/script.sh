#!/bin/bash

collapse_submenus() {
	sketchybar \
		--set '/logo\.sub\..*/' drawing=off
}

case "$SENDER" in
"mouse.clicked")
	if [[ "$MODIFIER" == "shift" ]]; then
		sketchybar --reload
	elif [[ "$BUTTON" == "right" ]]; then
		/System/Applications/Mission\ Control.app/Contents/MacOS/Mission\ Control
	else
		collapse_submenus
		sketchybar \
			--set wifi popup.drawing=off \
			--set battery popup.drawing=off \
			--set calendar popup.drawing=off \
			--set logo popup.drawing=toggle
	fi
	;;
"mouse.exited.global")
	collapse_submenus
	sketchybar --set logo popup.drawing=off
	;;
esac
