#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"

CORES=$(sysctl -n hw.logicalcpu)
LOAD=$(ps -A -o %cpu | awk -v c="$CORES" '{s+=$1} END {printf "%d", s/c}')

if   [ "$LOAD" -ge 80 ]; then COLOR=$RED
elif [ "$LOAD" -ge 50 ]; then COLOR=$ORANGE
else COLOR=$BLUE
fi

sketchybar --set "$NAME" icon.color="$COLOR" label="${LOAD}%"
