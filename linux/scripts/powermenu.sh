#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  power menu — bound to alt+shift+q on both Linux stacks.
#
#  Picker: wofi under Wayland, rofi under X11 (whichever exists).
#  Both are themed from CLAUDE.md §2 — wofi reads
#  ~/.config/wofi/powermenu.css, rofi gets the palette inline.
#
#  Installed by install.sh as ~/.local/bin/rice-powermenu.
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

# ── palette (§2) ───────────────────────────────────────────────
GB_BASE="#1d2021"
GB_SURFACE="#3c3836"
GB_TEXT="#ebdbb2"
GB_MUTED="#928374"
GB_ACCENT="#fabd2f"

ENTRIES=$'  lock\n  logout\n  suspend\n  reboot\n  shutdown'
PROMPT="power"

die() {
  command -v notify-send >/dev/null 2>&1 && notify-send -u critical "power menu" "$1"
  printf 'rice-powermenu: %s\n' "$1" >&2
  exit 1
}

# ── pick ───────────────────────────────────────────────────────
wofi_menu() {
  local style="$HOME/.config/wofi/powermenu.css" args=(--dmenu --prompt "$PROMPT"
    --width 260 --height 260 --lines 5 --hide-scroll --insensitive --cache-file /dev/null)
  [ -f "$style" ] && args+=(--style "$style")
  printf '%s\n' "$ENTRIES" | wofi "${args[@]}"
}

rofi_menu() {
  printf '%s\n' "$ENTRIES" | rofi -dmenu -i -p "$PROMPT" \
    -theme-str "
      * { background-color: ${GB_BASE}; text-color: ${GB_TEXT};
          font: \"Iosevka Nerd Font 12\"; }
      window   { width: 260px; border: 2px; border-color: ${GB_SURFACE};
                 border-radius: 10px; padding: 8px; }
      inputbar { children: [prompt]; padding: 4px 8px; text-color: ${GB_MUTED}; }
      prompt   { text-color: ${GB_MUTED}; }
      listview { lines: 5; spacing: 2px; }
      element  { padding: 6px 10px; border-radius: 6px; }
      element selected { background-color: ${GB_ACCENT}; text-color: ${GB_BASE}; }
    "
}

if [ -n "${WAYLAND_DISPLAY:-}" ] && command -v wofi >/dev/null 2>&1; then
  choice="$(wofi_menu || true)"
elif command -v rofi >/dev/null 2>&1; then
  choice="$(rofi_menu || true)"
elif command -v wofi >/dev/null 2>&1; then
  choice="$(wofi_menu || true)"
else
  die "no picker found — install wofi (Wayland) or rofi (X11)"
fi

[ -n "${choice:-}" ] || exit 0

# ── act ────────────────────────────────────────────────────────
lock() {
  for l in hyprlock swaylock i3lock; do
    command -v "$l" >/dev/null 2>&1 && { "$l"; return; }
  done
  loginctl lock-session 2>/dev/null || die "no locker found — install hyprlock or i3lock"
}

logout() {
  if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    hyprctl dispatch exit
  elif command -v i3-msg >/dev/null 2>&1 && i3-msg -t get_version >/dev/null 2>&1; then
    i3-msg exit
  else
    loginctl terminate-session "${XDG_SESSION_ID:-$(loginctl show-user "$USER" -p Display --value)}"
  fi
}

case "$choice" in
  *lock)     lock ;;
  *logout)   logout ;;
  *suspend)  systemctl suspend ;;
  *reboot)   systemctl reboot ;;
  *shutdown) systemctl poweroff ;;
esac
