#!/bin/bash
export RELPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$RELPATH/set_colors.sh"

if [[ "$SENDER" == "mouse.exited.global" ]]; then
	sketchybar --set "${NAME:-battery}" popup.drawing=off
	exit 0
fi

PMSET_OUT="$(pmset -g batt)"
PERCENTAGE="$(echo "$PMSET_OUT" | grep -Eo "[0-9]+%" | cut -d% -f1)"
ACCONNECTED="$(echo "$PMSET_OUT" | grep 'AC Power')"

if [[ -z "$PERCENTAGE" ]]; then
	exit 0
fi

COLOR=$TEXT

case ${PERCENTAGE} in
9[0-9] | 100) ICON=􀛨 ;;
[6-8][0-9])   ICON=􀺸 ;;
[3-5][0-9])   ICON=􀺶 ;;
[1-2][0-9])   ICON=􀛩; COLOR=$NOTICE ;;
*)            ICON=􀛪; COLOR=$CRITICAL ;;
esac

if [[ -n "$ACCONNECTED" ]]; then
	ICON=􀢋
fi

sketchybar --set "${NAME:-battery}" \
	icon="$ICON" \
	icon.color="$COLOR" \
	label="${PERCENTAGE}%" \
	drawing=on
