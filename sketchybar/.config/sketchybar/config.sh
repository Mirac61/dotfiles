# User configurable overrides for sketchybar-config
# Copy / edit this file or point SKETCHYBAR_CONFIG to an alternate path.
# All variables are optional; defaults are applied in sketchybarrc if unset.

# Width (in px) of the display notch reserved space
# Increase if music or other items are clipped near the notch
NOTCH_WIDTH=300

# Music title/subtitle info width (px)
MUSIC_INFO_WIDTH=80

# CPU graph update frequency (seconds)
CPU_UPDATE_FREQ=2

# Hide automatically menubar items (left click on logo)
MENUBAR_AUTOHIDE=false

# Included native menubar items 
# Replace " " by "__" and query with `sketchybar --query default_menu_items` 
MENU_CONTROLS=(
	"Control__Center,FocusModes"
	"Control__Center,Bluetooth"
)

# GITHUB Token path for notifications 
GITHUB_TOKEN="~/.github_token"

# Wifi unredactor path
WIFI_UNREDACTOR="~/Applications/wifi-unredactor.app"

# --- Design & Layout Presets ---
# BAR_DESIGN: "islands" (Keine Bar, keine Box, komplett transparent) | "glass" | "minimal" | "capsules"
BAR_DESIGN="islands"

# BAR_LOOK: "compact" (30px height) | "plain" (36px height)
BAR_LOOK="compact"

# COLOR_SCHEME: "kanagawa-dragon" | "macos-glass" | "catppuccin-mocha" | "tokyo-night" | "rosepine-moon"
COLOR_SCHEME="macos-glass"

# Enable translucent blur effect: true | false
BAR_TRANSPARENCY=true

# Hide workspaces that have no open windows (except the focused workspace): true | false
HIDE_EMPTY_SPACES=false

# How to display the user item in more-menu: "short" (mirac) | "full" (RealName) | "icon" (icon only)
USER_DISPLAY_MODE="short"

# Custom theme file fallback
THEME_FILE_PATH="$HOME/.config/sketchybar/theme.sh"

# Force a specific window manager
WINDOW_MANAGER="aerospace"
