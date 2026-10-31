#!/usr/bin/env bash
set -euo pipefail

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/tmux"
state_file="$state_dir/theme"
theme="${1:-}"

if [[ "$theme" == "--restore" ]]; then
  if [[ -f "$state_file" ]]; then
    theme="$(<"$state_file")"
  else
    theme="kanagawa/dragon"
  fi
fi

case "$theme" in
  vercel)
    base_theme="kanagawa/dragon"
    colors=(
      "text:#ededed"
      "bg-bar:#09090b"
      "bg-pane:#18181b"
      "highlight:#0070f3"
      "selection:#202b3c"
      "info:#a1a1aa"
      "accent:#0070f3"
      "notice:#f5a623"
      "error:#ee0000"
      "muted:#71717a"
      "alert:#f5a623"
    )
    ;;
  carbonfox)
    base_theme="kanagawa/dragon"
    colors=(
      "text:#f2f4f8"
      "bg-bar:#0c0c0c"
      "bg-pane:#161616"
      "highlight:#252525"
      "selection:#2a2a2a"
      "info:#33b1ff"
      "accent:#78a9ff"
      "notice:#08bdba"
      "error:#ee5396"
      "muted:#6e6f70"
      "alert:#be95ff"
    )
    ;;
  kanagawa/dragon)
    base_theme="$theme"
    colors=("accent:#8ba4b0" "selection:#3b5363")
    ;;
  kanagawa/wave)
    base_theme="$theme"
    colors=("accent:#7e9cd8" "selection:#3b5363")
    ;;
  kanagawa/lotus)
    base_theme="$theme"
    colors=("accent:#4d699b" "selection:#c9d7e5")
    ;;
  tokyonight/night)
    base_theme="$theme"
    colors=("accent:#7aa2f7" "selection:#29385e")
    ;;
  nord/default)
    base_theme="$theme"
    colors=("accent:#88c0d0" "selection:#34495e")
    ;;
  gruvbox/dark)
    base_theme="$theme"
    colors=("accent:#d79921" "selection:#50402a")
    ;;
  *)
    printf 'Unbekanntes Theme: %s\n' "$theme" >&2
    exit 2
    ;;
esac

mkdir -p "$state_dir"
tmp="$state_file.$$"
printf '%s\n' "$theme" > "$tmp"
mv "$tmp" "$state_file"

# Clear the prior palette so theme-specific overrides do not leak across themes.
for color in text bg-bar bg-pane highlight selection info accent notice error muted alert; do
  tmux set-option -gu "@ukiyo-color-$color" 2>/dev/null || true
done

tmux set-option -g @ukiyo-theme "$base_theme"
for entry in "${colors[@]}"; do
  tmux set-option -g "@ukiyo-color-${entry%%:*}" "${entry#*:}"
done

ukiyo_root="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tmux-ukiyo"
if [[ ! -x "$ukiyo_root/scripts/ukiyo.sh" ]]; then
  ukiyo_root="$HOME/.tmux/plugins/tmux-ukiyo"
fi
"$ukiyo_root/scripts/ukiyo.sh"
