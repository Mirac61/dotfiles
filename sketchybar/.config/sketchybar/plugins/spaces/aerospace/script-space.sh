#!/bin/bash

export RELPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
source "$RELPATH/set_colors.sh"
source "$RELPATH/icon_map.sh"

# Fast batched update of ALL aerospace workspaces + app icons in a single process & single sketchybar call
FOCUSED_WORKSPACE="${1:-${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}}"
ALL_WORKSPACES=($(aerospace list-workspaces --all 2>/dev/null))
ALL_WINDOWS="$(aerospace list-windows --all --format '%{workspace}|%{app-name}' 2>/dev/null | sort -u)"

STATE_FILE="${TMPDIR:-/tmp/}sketchybar_aerospace_state"
echo "${FOCUSED_WORKSPACE}_$(echo "$ALL_WINDOWS" | cksum | awk '{print $1}')" > "$STATE_FILE"

SBAR_ARGS=()

for sid in "${ALL_WORKSPACES[@]}"; do
	item="space.$sid"

	apps=$(echo "$ALL_WINDOWS" | awk -F'|' -v ws="$sid" '$1 == ws {print $2}')

	icon_strip=""
	has_apps="false"
	if [[ -n "$apps" ]]; then
		has_apps="true"
		while IFS= read -r app; do
			[[ -z "$app" ]] && continue
			__icon_map "$app"
			icon_strip+=" ${icon_result}"
		done <<<"$apps"
		icon_strip="${icon_strip# }"
	fi

	if [[ "$FOCUSED_WORKSPACE" == "$sid" ]]; then
		if [[ "$has_apps" == "true" ]]; then
			SBAR_ARGS+=(
				--set "$item"
				drawing=on
				background.drawing=on
				background.color="$SPACE_ACTIVE_BG"
				icon.highlight=on
				icon.color="$SPACE_ACTIVE_FG"
				icon.highlight_color="$SPACE_ACTIVE_FG"
				icon.padding_right=3
				label="$icon_strip"
				label.drawing=on
				label.highlight=on
				label.color="$SPACE_ACTIVE_FG"
				label.highlight_color="$SPACE_ACTIVE_FG"
				label.width=dynamic
			)
			FOCUSED_APP="$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null | head -n1)"
			if [[ -n "$FOCUSED_APP" ]]; then
				__icon_map "$FOCUSED_APP"
				SBAR_ARGS+=(
					--set front_app
					icon="$icon_result"
					icon.font="sketchybar-app-font:Regular:13.5"
					label="$FOCUSED_APP"
				)
			fi
		else
			# Empty active workspace: show prominent pill for the workspace and set front_app to Leer/Desktop
			SBAR_ARGS+=(
				--set "$item"
				drawing=on
				background.drawing=on
				background.color="$SPACE_ACTIVE_BG"
				icon.highlight=on
				icon.color="$SPACE_ACTIVE_FG"
				icon.highlight_color="$SPACE_ACTIVE_FG"
				icon.padding_right=7
				label=""
				label.drawing=off
				label.width=0
				--set front_app
				icon=􀏃
				icon.font="$FONT:Medium:12.5"
				label="Workspace $sid"
			)
		fi
	elif [[ "$has_apps" == "true" ]]; then
		SBAR_ARGS+=(
			--set "$item"
			drawing=on
			background.drawing=off
			icon.highlight=off
			icon.color="$TEXT"
			icon.padding_right=3
			label="$icon_strip"
			label.drawing=on
			label.highlight=off
			label.color="$SUBTLE"
			label.width=dynamic
		)
	else
		if [[ "$HIDE_EMPTY_SPACES" == "true" ]]; then
			SBAR_ARGS+=(
				--set "$item"
				drawing=off
				background.drawing=off
				label.drawing=off
			)
		else
			SBAR_ARGS+=(
				--set "$item"
				drawing=on
				background.drawing=off
				icon.highlight=off
				icon.color="$MUTED"
				icon.padding_right=7
				label=""
				label.drawing=off
				label.width=0
			)
		fi
	fi
done

if [[ ${#SBAR_ARGS[@]} -gt 0 ]]; then
	sketchybar "${SBAR_ARGS[@]}"
fi
