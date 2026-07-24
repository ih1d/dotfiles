#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"

BATT=$(pmset -g batt)
PERCENT=$(echo "$BATT" | grep -Eo '\d+%' | cut -d% -f1)
CHARGING=$(echo "$BATT" | grep -c 'AC Power')

[ -z "$PERCENT" ] && exit 0

if [ "$CHARGING" -ne 0 ]; then
  ICON=""
  COLOR=$GREEN
else
  case "$PERCENT" in
    100|9[0-9]) ICON=""; COLOR=$GREEN  ;;
    8[0-9]|7[0-9]|6[0-9]) ICON=""; COLOR=$GREEN  ;;
    5[0-9]|4[0-9]|3[0-9]) ICON=""; COLOR=$YELLOW ;;
    2[0-9]|1[0-9]) ICON=""; COLOR=$ORANGE ;;
    *) ICON=""; COLOR=$RED ;;
  esac
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENT}%"
