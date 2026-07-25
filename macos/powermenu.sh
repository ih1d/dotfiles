#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  power menu — bound to alt+shift+q, the macOS counterpart of
#  linux/scripts/powermenu.sh. Same entries, same order.
#
#  The picker is AppleScript's `choose from list`, so this needs
#  nothing installed. The cost: it is a native Aqua dialog and
#  CANNOT be themed — §2 does not reach it, the same way it does
#  not reach ly's console font on Linux. Do not fake it.
#
#  Installed by install.sh as ~/.local/bin/rice-powermenu.
#
#  "log out" / "restart" / "shut down" go through System Events,
#  so Terminal (or Ghostty) needs Automation permission for
#  System Events on first use — System Settings → Privacy &
#  Security → Automation. The macOS confirmation sheet still
#  appears for restart/shut down; that is macOS, not this script.
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

choice="$(osascript <<'APPLESCRIPT'
set entries to {"lock", "logout", "sleep", "restart", "shutdown"}
try
    set picked to choose from list entries ¬
        with title "power" ¬
        with prompt "power" ¬
        default items {"lock"}
on error
    return ""
end try
if picked is false then return ""
return item 1 of picked
APPLESCRIPT
)"

[ -n "$choice" ] || exit 0

case "$choice" in
  lock)     pmset displaysleepnow ;;
  logout)   osascript -e 'tell application "System Events" to log out' ;;
  sleep)    pmset sleepnow ;;
  restart)  osascript -e 'tell application "System Events" to restart' ;;
  shutdown) osascript -e 'tell application "System Events" to shut down' ;;
esac
