#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  macOS system polish for the gruvbox rice.
#  Everything here is reversible — see revert() at the bottom.
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

WALLPAPER="${1:-$HOME/Pictures/Wallpapers/gruvbox-ridge.png}"

apply() {
  echo "→ dark mode"
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true' || true

  echo "→ accent + highlight = gruvbox yellow"
  # AppleAccentColor: -1 graphite, 0 red, 1 orange, 2 yellow, 3 green, 4 blue, 5 purple, 6 pink
  defaults write NSGlobalDomain AppleAccentColor -int 2
  defaults write NSGlobalDomain AppleHighlightColor -string "0.980392 0.741176 0.184314 Yellow"

  echo "→ dock: autohide, instant, no recents"
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock autohide-delay -float 0
  defaults write com.apple.dock autohide-time-modifier -float 0.15
  defaults write com.apple.dock show-recents -bool false
  defaults write com.apple.dock tilesize -int 42
  defaults write com.apple.dock mineffect -string "scale"

  echo "→ menu bar: autohide (sketchybar takes the top strip)"
  defaults write NSGlobalDomain _HIHideMenuBar -bool true

  if [ -f "$WALLPAPER" ]; then
    echo "→ wallpaper: $WALLPAPER"
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\"" || true
  fi

  killall Dock 2>/dev/null || true
  echo "done. Log out and back in if the menu bar is still showing."
}

revert() {
  defaults delete NSGlobalDomain AppleAccentColor    2>/dev/null || true
  defaults delete NSGlobalDomain AppleHighlightColor 2>/dev/null || true
  defaults write  NSGlobalDomain _HIHideMenuBar -bool false
  defaults write  com.apple.dock autohide -bool false
  defaults delete com.apple.dock autohide-delay         2>/dev/null || true
  defaults delete com.apple.dock autohide-time-modifier 2>/dev/null || true
  killall Dock 2>/dev/null || true
  echo "reverted."
}

case "${1:-apply}" in
  revert) revert ;;
  *)      apply  ;;
esac
