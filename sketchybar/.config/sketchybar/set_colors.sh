#!/bin/bash
COLOR_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$COLOR_SCRIPT_DIR/log_handler.sh"
OS_VERSION="$(sw_vers -productVersion)"

# Config sourcing
if [[ -n "$SKETCHYBAR_CONFIG" && -f "$SKETCHYBAR_CONFIG" ]]; then
	# shellcheck disable=SC1090
	source "$SKETCHYBAR_CONFIG"
elif [[ -f "$COLOR_SCRIPT_DIR/config.sh" ]]; then
	# shellcheck disable=SC1091
	source "$COLOR_SCRIPT_DIR/config.sh"
fi

# Defaults & normalization
export COLOR_SCHEME="${COLOR_SCHEME:-kanagawa-dragon}"
export BAR_DESIGN="${BAR_DESIGN:-glass}"
export BAR_LOOK="${BAR_LOOK:-compact}"
export HIDE_EMPTY_SPACES="$(echo "${HIDE_EMPTY_SPACES:-true}" | tr '[:upper:]' '[:lower:]')"
export USER_DISPLAY_MODE="${USER_DISPLAY_MODE:-short}"
BAR_TRANSPARENCY_LOWER="$(echo "${BAR_TRANSPARENCY:-true}" | tr '[:upper:]' '[:lower:]')"
export BAR_TRANSPARENCY="$BAR_TRANSPARENCY_LOWER"
: "${THEME_FILE_PATH:="$COLOR_SCRIPT_DIR/theme.sh"}"

if [[ "$BAR_TRANSPARENCY" == "true" ]]; then
	ALPHA_BAR="cc"     # ~80% opacity
	ALPHA_ZONE="b3"    # ~70% opacity
	ALPHA_POPUP="e6"   # ~90% opacity
	ALPHA_BORDER="66"  # ~40% opacity
else
	ALPHA_BAR="ff"
	ALPHA_ZONE="ff"
	ALPHA_POPUP="ff"
	ALPHA_BORDER="ff"
fi

case "$COLOR_SCHEME" in
# Kanagawa Dragon (Warm Dark, matching Ghostty/Zellij palette)
"kanagawa-dragon")
	export BASE="0x${ALPHA_BAR}181616"
	export SURFACE="0x${ALPHA_ZONE}1d1c19"
	export OVERLAY="0x${ALPHA_ZONE}282727"
	export MUTED="0xff625e5a"
	export SUBTLE="0xff9e9b93"

	export TEXT="0xffc5c9c5"
	export CRITICAL="0xffc4746e"
	export NOTICE="0xffc4b28a"
	export WARN="0xffe46876"
	export SELECT="0xff8ba4b0"
	export GLOW="0xff8ea4a2"
	export ACTIVE="0xffc4b28a"

	export HIGH_LOW="0x${ALPHA_ZONE}22211f"
	export HIGH_MED="0x${ALPHA_BORDER}393836"
	export HIGH_HIGH="0xff625e5a"

	export BLACK="0xff0d0c0c"
	export TRANSPARENT="0x00000000"

	export BAR_COLOR="0x${ALPHA_BAR}161515"
	export BORDER_COLOR="0x${ALPHA_BORDER}393836"
	export ICON_COLOR="$TEXT"
	export LABEL_COLOR="$TEXT"

	export POPUP_BACKGROUND_COLOR="0x${ALPHA_POPUP}1d1c19"
	export POPUP_BORDER_COLOR="0xff393836"
	export SHADOW_COLOR="$BLACK"

	export SPACE_ACTIVE_BG="0xffc4b28a"
	export SPACE_ACTIVE_FG="0xff181616"
	export SPACE_INACTIVE_BG="0x99282727"
	export SPACE_INACTIVE_FG="0xffc5c9c5"
	export SPACE_EMPTY_FG="0xff625e5a"
	;;

# macOS Native Dark Glass (Sleek neutral translucent dark glass)
"macos-glass")
	if [[ "$BAR_TRANSPARENCY" == "true" ]]; then
		GLASS_BAR="94"
		GLASS_ZONE="88"
	else
		GLASS_BAR="ff"
		GLASS_ZONE="ff"
	fi

	export BASE="0x${GLASS_BAR}141416"
	export SURFACE="0x${GLASS_ZONE}1f1f24"
	export OVERLAY="0x${GLASS_ZONE}26262c"
	export MUTED="0xff8e8e93"
	export SUBTLE="0xffd1d1d6"

	export TEXT="0xffffffff"
	export CRITICAL="0xffff453a"
	export NOTICE="0xffffd60a"
	export WARN="0xffff9f0a"
	export SELECT="0xff0a84ff"
	export GLOW="0xff64d2ff"
	export ACTIVE="0xff5e5ce6"

	export HIGH_LOW="0x${GLASS_ZONE}202026"
	export HIGH_MED="0x38ffffff"
	export HIGH_HIGH="0x55ffffff"

	export BLACK="0xff000000"
	export TRANSPARENT="0x00000000"

	export BAR_COLOR="0x${GLASS_BAR}121214"
	export BORDER_COLOR="0x2effffff"
	export ICON_COLOR="$TEXT"
	export LABEL_COLOR="$TEXT"

	export POPUP_BACKGROUND_COLOR="0xe61c1c1e"
	export POPUP_BORDER_COLOR="0x38ffffff"
	export SHADOW_COLOR="$BLACK"

	export SPACE_ACTIVE_BG="0xfff5f5f7"
	export SPACE_ACTIVE_FG="0xff121214"
	export SPACE_INACTIVE_BG="0x772c2c2e"
	export SPACE_INACTIVE_FG="0xffe5e5ea"
	export SPACE_EMPTY_FG="0xff636366"
	;;

# Catppuccin Mocha
"catppuccin-mocha")
	export BASE="0x${ALPHA_BAR}1e1e2e"
	export SURFACE="0x${ALPHA_ZONE}313244"
	export OVERLAY="0x${ALPHA_ZONE}26273a"
	export MUTED="0xff6c7086"
	export SUBTLE="0xffa6adc8"

	export TEXT="0xffcdd6f4"
	export CRITICAL="0xfff38ba8"
	export NOTICE="0xfff9e2af"
	export WARN="0xffeba0ac"
	export SELECT="0xff89b4fa"
	export GLOW="0xff89dceb"
	export ACTIVE="0xffcba6f7"

	export HIGH_LOW="0x${ALPHA_ZONE}242536"
	export HIGH_MED="0x${ALPHA_BORDER}45475a"
	export HIGH_HIGH="0xff585b70"

	export BLACK="0xff11111b"
	export TRANSPARENT="0x00000000"

	export BAR_COLOR="0x${ALPHA_BAR}181825"
	export BORDER_COLOR="0x${ALPHA_BORDER}45475a"
	export ICON_COLOR="$TEXT"
	export LABEL_COLOR="$TEXT"

	export POPUP_BACKGROUND_COLOR="0x${ALPHA_POPUP}1e1e2e"
	export POPUP_BORDER_COLOR="0xff45475a"
	export SHADOW_COLOR="$BLACK"

	export SPACE_ACTIVE_BG="0xffcba6f7"
	export SPACE_ACTIVE_FG="0xff11111b"
	export SPACE_INACTIVE_BG="0x99313244"
	export SPACE_INACTIVE_FG="0xffcdd6f4"
	export SPACE_EMPTY_FG="0xff6c7086"
	;;

# Tokyo Night
"tokyo-night")
	export BASE="0x${ALPHA_BAR}1a1b26"
	export SURFACE="0x${ALPHA_ZONE}24283b"
	export OVERLAY="0x${ALPHA_ZONE}1f2335"
	export MUTED="0xff565f89"
	export SUBTLE="0xff9aa5ce"

	export TEXT="0xffc0caf5"
	export CRITICAL="0xfff7768e"
	export NOTICE="0xffe0af68"
	export WARN="0xffff9e64"
	export SELECT="0xff7aa2f7"
	export GLOW="0xff7dcfff"
	export ACTIVE="0xffbb9af7"

	export HIGH_LOW="0x${ALPHA_ZONE}1f2335"
	export HIGH_MED="0x${ALPHA_BORDER}414868"
	export HIGH_HIGH="0xff565f89"

	export BLACK="0xff15161e"
	export TRANSPARENT="0x00000000"

	export BAR_COLOR="0x${ALPHA_BAR}16161e"
	export BORDER_COLOR="0x${ALPHA_BORDER}3b4261"
	export ICON_COLOR="$TEXT"
	export LABEL_COLOR="$TEXT"

	export POPUP_BACKGROUND_COLOR="0x${ALPHA_POPUP}1a1b26"
	export POPUP_BORDER_COLOR="0xff414868"
	export SHADOW_COLOR="$BLACK"

	export SPACE_ACTIVE_BG="0xff7aa2f7"
	export SPACE_ACTIVE_FG="0xff15161e"
	export SPACE_INACTIVE_BG="0x9924283b"
	export SPACE_INACTIVE_FG="0xffc0caf5"
	export SPACE_EMPTY_FG="0xff565f89"
	;;

# Rosé Pine Moon
"rosepine-moon")
	export BASE="0x${ALPHA_BAR}232136"
	export SURFACE="0x${ALPHA_ZONE}2a273f"
	export OVERLAY="0x${ALPHA_ZONE}393552"
	export MUTED="0xff6e6a86"
	export SUBTLE="0xff908caa"

	export TEXT="0xffe0def4"
	export CRITICAL="0xffeb6f92"
	export NOTICE="0xfff6c177"
	export WARN="0xffea9a97"
	export SELECT="0xff3e8fb0"
	export GLOW="0xff9ccfd8"
	export ACTIVE="0xffc4a7e7"

	export HIGH_LOW="0x${ALPHA_ZONE}2a283e"
	export HIGH_MED="0x${ALPHA_BORDER}44415a"
	export HIGH_HIGH="0xff56526e"

	export BLACK="0xff181926"
	export TRANSPARENT="0x00000000"

	export BAR_COLOR="0x${ALPHA_BAR}232136"
	export BORDER_COLOR="0x${ALPHA_BORDER}44415a"
	export ICON_COLOR="$TEXT"
	export LABEL_COLOR="$TEXT"

	export POPUP_BACKGROUND_COLOR="0x${ALPHA_POPUP}2a273f"
	export POPUP_BORDER_COLOR="0xff44415a"
	export SHADOW_COLOR="$BLACK"

	export SPACE_ACTIVE_BG="0xffc4a7e7"
	export SPACE_ACTIVE_FG="0xff181926"
	export SPACE_INACTIVE_BG="0x99393552"
	export SPACE_INACTIVE_FG="0xffe0def4"
	export SPACE_EMPTY_FG="0xff6e6a86"
	;;

*)
	if [[ -n "$THEME_FILE_PATH" && -f "$THEME_FILE_PATH" ]]; then
		sendLog "Theme specified isn't a default theme ($COLOR_SCHEME), Loading custom theme file $THEME_FILE_PATH" "info"
		source "$THEME_FILE_PATH"
		: "${SPACE_ACTIVE_BG:=$ACTIVE}"
		: "${SPACE_ACTIVE_FG:=$BLACK}"
		: "${SPACE_INACTIVE_BG:=$HIGH_LOW}"
		: "${SPACE_INACTIVE_FG:=$TEXT}"
		: "${SPACE_EMPTY_FG:=$MUTED}"
	else
		sendErr "Theme specified isn't a default theme ($COLOR_SCHEME) and no theme.sh was specified" "info"
		exit
	fi
	;;
esac
