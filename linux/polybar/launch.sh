#!/bin/sh
# ═══════════════════════════════════════════════════════════════
#  Launch one `rice` bar per connected monitor (X11 / i3).
#  i3 calls this from exec_always, so it must be idempotent.
#  Logs land in /tmp/polybar-<monitor>.log for debugging.
# ═══════════════════════════════════════════════════════════════
set -u

polybar-msg cmd quit >/dev/null 2>&1 || true

# give the old instances up to ~2s to release their IPC sockets, then insist
i=0
while pgrep -x -u "$(id -u)" polybar >/dev/null 2>&1; do
  i=$((i + 1))
  [ "$i" -ge 10 ] && { pkill -x -u "$(id -u)" polybar >/dev/null 2>&1; break; }
  sleep 0.2
done

for m in $(polybar --list-monitors | cut -d: -f1); do
  MONITOR="$m" polybar --reload rice >"/tmp/polybar-$m.log" 2>&1 &
done
