#!/bin/bash
export RELPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$RELPATH/set_colors.sh"

case "${USER_DISPLAY_MODE:-short}" in
"full")
	RealName=$(dscl . -read /Users/"$(whoami)" RealName 2>/dev/null | awk '/RealName: / {gsub("RealName: ",""); print}')
	if [[ -z "$RealName" ]]; then
		RealName=$(dscl . -read /Users/"$(whoami)" RealName 2>/dev/null | awk 'NR>1 {sub(/^[[:space:]]*/, ""); print; exit}')
	fi
	sketchybar --set "$NAME" label="${RealName:-$(whoami)}" label.drawing=on
	;;
"icon")
	sketchybar --set "$NAME" label="" label.drawing=off
	;;
*)
	# Default: short username (e.g. mirac)
	sketchybar --set "$NAME" label="$(whoami)" label.drawing=on
	;;
esac

sendLog "Updated user (${USER_DISPLAY_MODE:-short})" "vomit"
