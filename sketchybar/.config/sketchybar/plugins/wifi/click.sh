#!/bin/bash
export RELPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if [[ "$1" == "toggle" ]]; then
	sketchybar --set wifi popup.drawing=off
	WIFI_PORT=$(networksetup -listallhardwareports 2>/dev/null | awk '/Hardware Port: Wi-Fi/{getline; print $2}')
	[[ -z "$WIFI_PORT" ]] && WIFI_PORT="en0"
	POWER_STATE=$(networksetup -getairportpower "$WIFI_PORT" 2>/dev/null | awk '{print $NF}')
	if [[ "$POWER_STATE" == "On" ]]; then
		networksetup -setairportpower "$WIFI_PORT" off
	else
		networksetup -setairportpower "$WIFI_PORT" on
	fi
	sleep 1
	"$RELPATH/plugins/wifi/script.sh"
	exit 0
fi

# Instant popup toggle (0ms latency) and close other popups
sketchybar \
	--set logo popup.drawing=off \
	--set battery popup.drawing=off \
	--set calendar popup.drawing=off \
	--set wifi popup.drawing=toggle

# Refresh network info asynchronously
WIFI_PORT=$(networksetup -listallhardwareports 2>/dev/null | awk '/Hardware Port: Wi-Fi/{getline; print $2}')
[[ -z "$WIFI_PORT" ]] && WIFI_PORT="en0"
POWER_STATE=$(networksetup -getairportpower "$WIFI_PORT" 2>/dev/null | awk '{print $NF}')
IP_ADDR=$(ipconfig getifaddr "$WIFI_PORT" 2>/dev/null)
ROUTER_IP=$(netstat -nr -f inet 2>/dev/null | awk '$1 == "default" {print $2; exit}')
SSID=$(ipconfig getsummary "$WIFI_PORT" 2>/dev/null | awk -F': ' '/ SSID : / {print $2}')

if [[ "$POWER_STATE" != "On" ]]; then
	STATUS_LABEL="WLAN ausgeschaltet ($WIFI_PORT)"
	TOGGLE_LABEL="WLAN einschalten"
	TOGGLE_ICON=􀙇
elif [[ -n "$IP_ADDR" ]]; then
	if [[ -n "$SSID" && "$SSID" != "<redacted>" ]]; then
		STATUS_LABEL="Verbunden: $SSID"
	else
		STATUS_LABEL="Verbunden ($WIFI_PORT)"
	fi
	TOGGLE_LABEL="WLAN ausschalten"
	TOGGLE_ICON=􀙈
else
	STATUS_LABEL="Nicht verbunden"
	TOGGLE_LABEL="WLAN ausschalten"
	TOGGLE_ICON=􀙈
fi

sketchybar \
	--set wifi.status label="$STATUS_LABEL" \
	--set wifi.ip label="IP: ${IP_ADDR:-Keine} (Kopieren)" \
		click_script="printf '%s' '${IP_ADDR}' | pbcopy; sketchybar --set wifi popup.drawing=off" \
	--set wifi.router label="Router: ${ROUTER_IP:-Keine} (Kopieren)" \
		click_script="printf '%s' '${ROUTER_IP}' | pbcopy; sketchybar --set wifi popup.drawing=off" \
	--set wifi.toggle icon="$TOGGLE_ICON" label="$TOGGLE_LABEL"
