#!/bin/bash
export RELPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$RELPATH/set_colors.sh"

VOLUME=$(osascript -e 'input volume of (get volume settings)' 2>/dev/null)
[[ -z "$VOLUME" ]] && VOLUME=50

if [[ "$SENDER" == "mouse.clicked" ]]; then
	if [[ "$VOLUME" -eq 0 ]]; then
		osascript -e 'set volume input volume 75' 2>/dev/null
		VOLUME=75
	else
		osascript -e 'set volume input volume 0' 2>/dev/null
		VOLUME=0
	fi
fi

if [[ "$VOLUME" -eq 0 ]]; then
	ICON=􀊲
	COLOR=$MUTED
else
	ICON=􀊱
	COLOR=$TEXT
fi

sketchybar --set "${NAME:-mic}" icon="$ICON" icon.color="$COLOR"
