#!/bin/bash
export RELPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$RELPATH/set_colors.sh"

if [[ "$SENDER" == "mouse.exited.global" ]]; then
	sketchybar --set "${NAME:-wifi}" popup.drawing=off
	exit 0
fi

WIFI_PORT=$(networksetup -listallhardwareports 2>/dev/null | awk '/Hardware Port: Wi-Fi/{getline; print $2}')
[[ -z "$WIFI_PORT" ]] && WIFI_PORT="en0"

IP_ADDRESS=$(ipconfig getifaddr "$WIFI_PORT" 2>/dev/null)
POWER_STATE=$(networksetup -getairportpower "$WIFI_PORT" 2>/dev/null | awk '{print $NF}')

if [[ "$POWER_STATE" == "Off" ]]; then
	ICON=􀙈
	ICON_COLOR=$MUTED
elif [[ -n "$IP_ADDRESS" ]]; then
	ICON=􀙇
	ICON_COLOR=$TEXT
else
	ICON=􀙥
	ICON_COLOR=$MUTED
fi

sketchybar --set "${NAME:-wifi}" \
	icon="$ICON" \
	icon.color="$ICON_COLOR" \
	label.drawing=off
