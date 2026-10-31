#!/bin/bash

# Instant popup toggle (0ms latency) and close other popups
sketchybar \
	--set logo popup.drawing=off \
	--set wifi popup.drawing=off \
	--set calendar popup.drawing=off \
	--set battery popup.drawing=toggle

PMSET_OUT="$(pmset -g batt)"
PERCENTAGE="$(echo "$PMSET_OUT" | grep -Eo "[0-9]+%" | cut -d% -f1)"
REMAINING="$(echo "$PMSET_OUT" | grep -Eo "[0-9]+:[0-9]+ remaining" | awk '{print $1}')"
ACCONNECTED="$(echo "$PMSET_OUT" | grep 'AC Power')"

if [[ -n "$ACCONNECTED" ]]; then
	SOURCE_STR="Netzteil angeschlossen ($PERCENTAGE%)"
else
	SOURCE_STR="Batteriebetrieb ($PERCENTAGE%)"
fi

if [[ -n "$REMAINING" ]]; then
	TIME_STR="Verbleibend: ${REMAINING} Std."
elif [[ -n "$ACCONNECTED" ]]; then
	TIME_STR="Wird geladen / Vollständig geladen"
else
	TIME_STR="Restlaufzeit wird berechnet..."
fi

sketchybar \
	--set battery.status label="$SOURCE_STR" \
	--set battery.time label="$TIME_STR"
