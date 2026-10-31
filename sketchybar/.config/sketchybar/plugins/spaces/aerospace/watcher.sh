#!/bin/bash

export RELPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
STATE_FILE="${TMPDIR:-/tmp/}sketchybar_aerospace_state"

FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
WINDOWS_HASH=$(aerospace list-windows --all --format '%{workspace}|%{app-name}' 2>/dev/null | sort -u | cksum | awk '{print $1}')
CURRENT_STATE="${FOCUSED}_${WINDOWS_HASH}"

LAST_STATE=""
[[ -f "$STATE_FILE" ]] && LAST_STATE=$(cat "$STATE_FILE" 2>/dev/null)

if [[ "$CURRENT_STATE" != "$LAST_STATE" && -n "$FOCUSED" ]]; then
	echo "$CURRENT_STATE" > "$STATE_FILE"
	"$RELPATH/plugins/spaces/aerospace/script-space.sh" "$FOCUSED"
fi
