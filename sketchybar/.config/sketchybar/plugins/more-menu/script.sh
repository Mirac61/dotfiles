#!/bin/bash
export RELPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$RELPATH/set_colors.sh"
shopt -s expand_aliases
command -v 'ft-haptic' 2>/dev/null 1>&2 || alias ft-haptic="$RELPATH/ft-haptic"

menuitems=($1)
INNER_PADDINGS=$2
FONT="$3"

ICON_VALUE="$(sketchybar --query "$NAME" | sed 's/\\n//g; s/\\\$//g; s/\\ //g' | jq -r '.icon.value')"
GRAPHSTATE="$(sketchybar --query graph | sed 's/\\n//g; s/\\\$//g; s/\\ //g' | jq -r '.geometry.drawing')"

if [[ "$ICON_VALUE" == "􀯻" || "$ICON_VALUE" == "|" ]]; then
	STATE=on
else
	STATE=off
fi

menu_set() {
	sendLog "Toggle moremenu to $1" "debug"

	for item in "${menuitems[@]}"; do
		item=$(echo "$item" | sed -e "s/__/ /g")
		sketchybar --animate tanh 15 \
			--set "$item" drawing="$1"
	done

	if [[ "$1" == "on" ]]; then
		separator=(
			icon="􀯻"
			icon.color="$ACTIVE"
			icon.font="$FONT:Semibold:13.0"
			icon.padding_left="$INNER_PADDINGS"
			icon.padding_right="$INNER_PADDINGS"
		)
		sketchybar --set "$NAME" icon.y_offset=0 \
			--animate tanh 15 \
			--set "$NAME" "${separator[@]}"
		sketchybar --trigger more-menu-update
	else
		separator=(
			icon="􀯶"
			icon.color="$SUBTLE"
			icon.font="$FONT:Semibold:13.0"
			icon.padding_left="$INNER_PADDINGS"
			icon.padding_right="$INNER_PADDINGS"
		)
		sketchybar --set "$NAME" icon.y_offset=0 \
			--animate tanh 15 \
			--set "$NAME" "${separator[@]}"
	fi
}

graph_set() {
	sendLog "Toggle graph to $1" "debug"

	if [[ "$1" == "off" ]]; then
		icon=􀯶
	else
		icon=􀫰
	fi

	sketchybar --set '/graph.*/' drawing="$1" \
		--set "$NAME" icon="$icon" \
		--trigger activities_update

	[[ "$1" == "off" ]] && for ((i = 0; i <= 140; ++i)); do
		sketchybar --push graph 0.0
	done
}

case "$SENDER" in
"mouse.entered")
	ft-haptic -n 1 2>/dev/null || true
	;;
"mouse.clicked")
	if [[ "$STATE" == "off" ]]; then
		if [[ "$MODIFIER" == "alt" && "$GRAPHSTATE" == "off" ]]; then
			graph_set "on"
		elif [[ "$GRAPHSTATE" == "on" ]]; then
			graph_set "off"
		else
			menu_set "on"
		fi
	else
		menu_set "off"
	fi
	;;
esac
