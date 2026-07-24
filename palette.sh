#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  Gruvbox Dark — the single source of truth for this rice.
#  Every config in this repo draws from these values. If you
#  change a colour, change it HERE first, then propagate.
#
#  Usage:  source palette.sh
# ═══════════════════════════════════════════════════════════════

# ── backgrounds (dark → light) ────────────────────────────────
export GB_BG0_H="#1d2021"   # hard background — the base of everything
export GB_BG0="#282828"     # standard background
export GB_BG1="#3c3836"     # panels, inactive borders
export GB_BG2="#504945"     # selections, item chips
export GB_BG3="#665c54"     # separators, empty-state icons
export GB_BG4="#7c6f64"

# ── foregrounds (light → dark) ────────────────────────────────
export GB_FG0="#fbf1c7"
export GB_FG1="#ebdbb2"     # primary text
export GB_FG2="#d5c4a1"
export GB_FG3="#bdae93"     # secondary text
export GB_FG4="#a89984"
export GB_GRAY="#928374"    # muted / disabled

# ── accents, normal ───────────────────────────────────────────
export GB_RED="#cc241d"
export GB_GREEN="#98971a"
export GB_YELLOW="#d79921"
export GB_BLUE="#458588"
export GB_PURPLE="#b16286"
export GB_AQUA="#689d6a"
export GB_ORANGE="#d65d0e"

# ── accents, bright (used for anything on a dark bg) ──────────
export GB_RED_B="#fb4934"
export GB_GREEN_B="#b8bb26"
export GB_YELLOW_B="#fabd2f"    # ★ THE accent colour of this rice
export GB_BLUE_B="#83a598"
export GB_PURPLE_B="#d3869b"
export GB_AQUA_B="#8ec07c"
export GB_ORANGE_B="#fe8019"

# ── semantic roles ────────────────────────────────────────────
# Use these names when porting to a new tool, not raw hex.
export GB_ACCENT="$GB_YELLOW_B"        # focused window border, active workspace, prompt
export GB_BASE="$GB_BG0_H"             # window/terminal/bar background
export GB_TEXT="$GB_FG1"               # default text
export GB_MUTED="$GB_GRAY"             # inactive workspace numbers, hints
export GB_SURFACE="$GB_BG1"            # unfocused border, bar border
export GB_CHIP="$GB_BG2"               # a raised element sitting on the bar
export GB_OK="$GB_GREEN_B"             # battery healthy, git clean
export GB_WARN="$GB_ORANGE_B"          # load 50-80%, battery 10-30%
export GB_CRIT="$GB_RED_B"             # load >80%, battery <10%
export GB_INFO="$GB_BLUE_B"            # cpu, links
export GB_ALT="$GB_PURPLE_B"           # ram, secondary metric

# 0xAARRGGBB variants — SketchyBar and JankyBorders want this form
hex2argb() { printf '0xff%s' "${1#\#}"; }
