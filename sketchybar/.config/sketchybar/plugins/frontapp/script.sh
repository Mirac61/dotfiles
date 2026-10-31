#!/bin/bash
export RELPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$RELPATH/icon_map.sh"
source "$RELPATH/log_handler.sh"

APP_NAME="$INFO"
if [[ -z "$APP_NAME" ]]; then
	APP_NAME="$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null | head -n1)"
fi
if [[ -z "$APP_NAME" ]]; then
	APP_NAME="$(lsappinfo info -only name "$(lsappinfo front)" 2>/dev/null | cut -d'"' -f4)"
fi

if [[ -n "$APP_NAME" ]]; then
	__icon_map "$APP_NAME"
	sketchybar --set "$NAME" label="$APP_NAME" icon="$icon_result"
else
	sendErr "Can't fetch frontapp name" "debug"
fi
