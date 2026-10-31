#!/bin/bash

SPACE_PILL_HEIGHT=$(($ZONE_HEIGHT - 4))
SPACE_PILL_RADIUS=$(($ZONE_CORNER_RADIUS - 2))
[[ $SPACE_PILL_RADIUS -lt 6 ]] && SPACE_PILL_RADIUS=6

## Space item with app icons
dummy_space=(
	icon.padding_left=7
	icon.padding_right=4
	icon.font="$FONT:Bold:12.0"
	icon.color=$SUBTLE
	icon.highlight_color=$SPACE_ACTIVE_FG
	padding_left=2
	padding_right=2
	background.color=$SPACE_ACTIVE_BG
	background.height=$SPACE_PILL_HEIGHT
	background.corner_radius=$SPACE_PILL_RADIUS
	background.border_width=0
	background.drawing=off
	label.padding_left=2
	label.padding_right=7
	label.font="sketchybar-app-font:Regular:13.5"
	label.color=$SUBTLE
	label.highlight_color=$SPACE_ACTIVE_FG
	label.y_offset=-1
	label.drawing=off
	label.width=dynamic
)

separator=(
	icon="·"
	label.drawing=off
	icon.font="$FONT:Bold:14.0"
	associated_display=active
	icon.color=$MUTED
	icon.padding_left=4
	icon.padding_right=4
)

addYabaiSpaces() {
	for sid in "${SPACES[@]}"; do
		space=("${dummy_space[@]}")
		space+=(
			associated_space=$sid
			icon="$sid"
			script="$SCRIPT_SPACES"
		)
		sketchybar --add space space.$sid left \
			--set space.$sid "${space[@]}" \
			--subscribe space.$sid mouse.clicked
	done

	sketchybar --add item separator left \
		--set separator "${separator[@]}" \
		--subscribe separator space_windows_change
}

addAerospaceSpaces() {
	sketchybar --add event aerospace_workspace_change
	rm -f "${TMPDIR:-/tmp/}sketchybar_aerospace_state"

	for sid in "${SPACES[@]}"; do
		space=("${dummy_space[@]}")
		space+=(
			icon="$sid"
			click_script="export PATH=$PATH; aerospace workspace $sid 2>/dev/null; $RELPATH/plugins/spaces/aerospace/script-space.sh $sid"
			drawing=on
		)

		sketchybar --add item space.$sid left \
			--set space.$sid "${space[@]}"
	done

	separator+=(
		script="export PATH=$PATH; $RELPATH/plugins/spaces/aerospace/watcher.sh"
		update_freq=1
		updates=on
	)

	sketchybar --add item separator left \
		--set separator "${separator[@]}" \
		--subscribe separator aerospace_workspace_change front_app_switched space_windows_change routine system_woke

	"$RELPATH/plugins/spaces/aerospace/script-space.sh" &
}

addRiftSpaces() {
	sketchybar --add event rift_workspace_changed
	for sid in "${SPACES[@]}"; do
		space=("${dummy_space[@]}")
		space+=(
			icon="$sid"
			script="$SCRIPT_SPACES $workspace"
			drawing=on
		)
		sid=$(echo "$sid" | sed 's/ /__/g')
		sketchybar --add item space.$sid left \
			--set space.$sid "${space[@]}" \
			--subscribe space.$sid rift_workspace_changed mouse.clicked
	done
	sketchybar --add item separator left --set separator "${separator[@]}"
}

case "$WINDOW_MANAGER" in
"yabai")
	SCRIPT_SPACES="export PATH=$PATH; $RELPATH/plugins/spaces/yabai/script-space.sh"
	SCRIPT_SPACE_WINDOWS="export PATH=$PATH; $RELPATH/plugins/spaces/yabai/script-windows.sh"
	SPACES=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
	addYabaiSpaces
	;;
"aerospace")
	SCRIPT_SPACES="export PATH=$PATH; $RELPATH/plugins/spaces/aerospace/script-space.sh"
	SCRIPT_SPACE_WINDOWS="export PATH=$PATH; $RELPATH/plugins/spaces/aerospace/script-windows.sh"
	SPACES=($(aerospace list-workspaces --all 2>/dev/null))
	addAerospaceSpaces
	;;
"rift")
	SCRIPT_SPACES="export PATH=$PATH; $RELPATH/plugins/spaces/rift/script-space.sh"
	SCRIPT_SPACE_WINDOWS="export PATH=$PATH; $RELPATH/plugins/spaces/rift/script-windows.sh"
	while IFS= read -r line; do
		SPACES+=("$line")
	done < <(rift-cli query workspaces 2>/dev/null | jq -r '.[] | .name')
	addRiftSpaces
	;;
esac
