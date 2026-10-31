#!/bin/bash

case "$SENDER" in
"mouse.clicked")
	sketchybar --set "$NAME" popup.drawing=toggle
	;;
"mouse.exited.global")
	sketchybar --set "$NAME" popup.drawing=off
	;;
esac
