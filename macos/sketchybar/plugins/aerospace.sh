#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"

# $1 = workspace id this item represents
# $FOCUSED_WORKSPACE comes from the aerospace_workspace_change trigger
if [ -z "$FOCUSED_WORKSPACE" ]; then
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
fi

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" background.drawing=on \
                          background.color=$ACCENT \
                          icon.color=$BG0_H
else
  # dim workspaces that hold no windows at all
  if aerospace list-windows --workspace "$1" 2>/dev/null | grep -q .; then
    sketchybar --set "$NAME" background.drawing=off icon.color=$FG3
  else
    sketchybar --set "$NAME" background.drawing=off icon.color=$BG3
  fi
fi
