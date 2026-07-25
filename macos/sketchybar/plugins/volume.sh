#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
else
  VOLUME=$(osascript -e 'output volume of (get volume settings)')
fi

case "$VOLUME" in
  [6-9][0-9]|100) ICON="" ;;
  [3-5][0-9])     ICON="" ;;
  [1-9]|[1-2][0-9]) ICON="" ;;
  *) ICON="󰝟" ;;
esac

sketchybar --set "$NAME" icon="$ICON" icon.color=$AQUA label="${VOLUME}%"
