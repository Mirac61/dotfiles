#!/bin/bash

if [[ "$SENDER" == "mouse.exited.global" ]]; then
	sketchybar --set "${NAME:-calendar}" popup.drawing=off
	exit 0
fi

sketchybar \
	--set "${NAME:-calendar}" icon="$(date '+%a %d. %b')" label="$(date '+%H:%M')" \
	--set calendar.header label="$(date '+%A, %d. %B')" \
	--set calendar.sub label="$(date '+Kalenderwoche %V  •  %Y')" \
	--set calendar.copy label="Datum kopieren ($(date '+%Y-%m-%d'))"
