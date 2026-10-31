#!/bin/bash

export RELPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
source "$RELPATH/set_colors.sh"
source "$RELPATH/icon_map.sh"

# Fast batched update of ALL aerospace workspaces + app icons in a single process & single sketchybar call
FOCUSED_WORKSPACE="${1:-${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}}"
WORKSPACE_INFO="$(aerospace list-workspaces --all --format '%{workspace}|%{monitor-appkit-nsscreen-screens-id}|%{workspace-is-visible}' 2>/dev/null)"
ALL_WINDOWS="$(aerospace list-windows --all --format '%{workspace}|%{app-name}' 2>/dev/null | sort -u)"

STATE_FILE="${TMPDIR:-/tmp/}sketchybar_aerospace_state"
echo "${FOCUSED_WORKSPACE}_$(echo "$WORKSPACE_INFO $ALL_WINDOWS" | cksum | awk '{print $1}')" > "$STATE_FILE"

SBAR_ARGS=()

while IFS='|' read -r sid disp_id is_vis; do
	[[ -z "$sid" ]] && continue
	item="space.$sid"

	if ! sketchybar --query "$item" >/dev/null 2>&1; then
		sketchybar --add item "$item" left \
			--set "$item" \
			icon="$sid" \
			icon.padding_left=7 \
			icon.padding_right=4 \
			icon.font="SF Pro:Bold:12.0" \
			icon.color="$SUBTLE" \
			icon.highlight_color="$SPACE_ACTIVE_FG" \
			padding_left=2 \
			padding_right=2 \
			background.color="$SPACE_ACTIVE_BG" \
			background.height=20 \
			background.corner_radius=6 \
			background.border_width=0 \
			background.drawing=off \
			label.padding_left=2 \
			label.padding_right=7 \
			label.font="sketchybar-app-font:Regular:13.5" \
			label.color="$SUBTLE" \
			label.highlight_color="$SPACE_ACTIVE_FG" \
			label.y_offset=-1 \
			label.drawing=off \
			label.width=dynamic \
			click_script="export PATH=$PATH; aerospace workspace $sid 2>/dev/null; $RELPATH/plugins/spaces/aerospace/script-space.sh $sid"
	fi

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

	DISP_ARG=()
	[[ -n "$disp_id" ]] && DISP_ARG=(display="$disp_id")

	if [[ "$FOCUSED_WORKSPACE" == "$sid" || "$is_vis" == "true" ]]; then
		ACTIVE_BG="$SPACE_ACTIVE_BG"
		ACTIVE_FG="$SPACE_ACTIVE_FG"
		if [[ "$FOCUSED_WORKSPACE" != "$sid" ]]; then
			# Visible workspace on unfocused monitor: subtle highlight pill
			ACTIVE_BG="$HIGH_MED"
			ACTIVE_FG="$TEXT"
		fi
		if [[ "$has_apps" == "true" ]]; then
			SBAR_ARGS+=(
				--set "$item"
				"${DISP_ARG[@]}"
				drawing=on
				background.drawing=on
				background.color="$ACTIVE_BG"
				icon.highlight=on
				icon.color="$ACTIVE_FG"
				icon.highlight_color="$ACTIVE_FG"
				icon.padding_right=3
				label="$icon_strip"
				label.drawing=on
				label.highlight=on
				label.color="$ACTIVE_FG"
				label.highlight_color="$ACTIVE_FG"
				label.width=dynamic
			)
			if [[ "$FOCUSED_WORKSPACE" == "$sid" ]]; then
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
			fi
		else
			# Empty active/visible workspace: show pill for the workspace
			SBAR_ARGS+=(
				--set "$item"
				"${DISP_ARG[@]}"
				drawing=on
				background.drawing=on
				background.color="$ACTIVE_BG"
				icon.highlight=on
				icon.color="$ACTIVE_FG"
				icon.highlight_color="$ACTIVE_FG"
				icon.padding_right=7
				label=""
				label.drawing=off
				label.width=0
			)
			if [[ "$FOCUSED_WORKSPACE" == "$sid" ]]; then
				SBAR_ARGS+=(
					--set front_app
					icon=􀏃
					icon.font="$FONT:Medium:12.5"
					label="Workspace $sid"
				)
			fi
		fi
	elif [[ "$has_apps" == "true" ]]; then
		SBAR_ARGS+=(
			--set "$item"
			"${DISP_ARG[@]}"
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
				"${DISP_ARG[@]}"
				drawing=off
				background.drawing=off
				label.drawing=off
			)
		else
			SBAR_ARGS+=(
				--set "$item"
				"${DISP_ARG[@]}"
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
done <<<"$WORKSPACE_INFO"

if [[ ${#SBAR_ARGS[@]} -gt 0 ]]; then
	sketchybar "${SBAR_ARGS[@]}"
fi
