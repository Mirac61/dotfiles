#!/bin/bash

SCRIPT_WIFI="export PATH=$PATH; $RELPATH/plugins/wifi/script.sh $WIFI_UNREDACTOR"
SCRIPT_CLICK_WIFI="export PATH=$PATH; $RELPATH/plugins/wifi/click.sh"
HOVER_SCRIPT="export PATH=$PATH; $RELPATH/plugins/popup_hover.sh"

wifi=(
	script="$SCRIPT_WIFI"
	click_script="$SCRIPT_CLICK_WIFI"
	label=""
	label.drawing=off
	icon=􀙇
	icon.font="$FONT:Regular:13.5"
	icon.color=$TEXT
	icon.padding_left=5
	icon.padding_right=5
	padding_left=2
	padding_right=2
	popup.align=right
	popup.y_offset=6
	popup.background.border_width=1
	popup.background.corner_radius=10
	popup.background.border_color=$POPUP_BORDER_COLOR
	popup.background.color=$POPUP_BACKGROUND_COLOR
	popup.blur_radius=25
	popup.background.shadow.drawing=on
)

popup_row=(
	icon.font="$FONT:Medium:11.5"
	icon.color=$SUBTLE
	icon.padding_left=10
	icon.padding_right=6
	label.font="$FONT:Medium:12.0"
	label.color=$TEXT
	label.padding_right=14
	padding_left=4
	padding_right=4
	background.corner_radius=6
	background.height=24
	background.color=$HIGH_MED
	background.drawing=off
	script="$HOVER_SCRIPT"
)

sketchybar --add item wifi right \
	--set wifi "${wifi[@]}" \
	--subscribe wifi wifi_change mouse.exited.global \
	--add item wifi.status popup.wifi \
	--set wifi.status \
		icon=􀙇 \
		icon.font="$FONT:Semibold:12.0" \
		icon.color=$TEXT \
		icon.padding_left=12 \
		icon.padding_right=6 \
		label="WLAN verbunden" \
		label.font="$FONT:Semibold:12.0" \
		label.color=$TEXT \
		label.padding_right=14 \
		background.height=24 \
		background.drawing=off \
	--add item wifi.ip popup.wifi \
	--set wifi.ip "${popup_row[@]}" icon=􀆪 label="IP kopieren" \
	--subscribe wifi.ip mouse.entered mouse.exited \
	--add item wifi.toggle popup.wifi \
	--set wifi.toggle "${popup_row[@]}" icon=􀆨 label="WLAN ausschalten" click_script="$SCRIPT_CLICK_WIFI toggle" \
	--subscribe wifi.toggle mouse.entered mouse.exited \
	--add item wifi.settings popup.wifi \
	--set wifi.settings "${popup_row[@]}" icon=􀍟 label="Netzwerk-Einstellungen…" click_script="sketchybar --set wifi popup.drawing=off; open 'x-apple.systempreferences:com.apple.wifi-settings-extension'" \
	--subscribe wifi.settings mouse.entered mouse.exited
