#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"

FREE=$(memory_pressure | awk '/System-wide memory free percentage/ {gsub("%","",$5); print $5}')
[ -z "$FREE" ] && exit 0
USED=$((100 - FREE))

if   [ "$USED" -ge 85 ]; then COLOR=$RED
elif [ "$USED" -ge 65 ]; then COLOR=$ORANGE
else COLOR=$PURPLE
fi

sketchybar --set "$NAME" icon.color="$COLOR" label="${USED}%"
