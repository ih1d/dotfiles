#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  gruvbox-ridge wallpaper generator
#
#    ./make_wallpaper.sh                 3840x2160 (default)
#    W=2560 H=1440 ./make_wallpaper.sh   any resolution
#    OUT=~/foo.png ./make_wallpaper.sh   custom destination
#
#  Requires ImageMagick 7 (`magick`).
#  Colours are from palette.sh — see CLAUDE.md §2.
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

W=${W:-3840}
H=${H:-2160}
OUT=${OUT:-"$HOME/Pictures/Wallpapers/gruvbox-ridge.png"}

command -v magick >/dev/null || { echo "needs ImageMagick 7 (magick)"; exit 1; }

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$(dirname "$OUT")"

# Irregular but deterministic peak heights, so the ridges don't read
# as a sawtooth. Index i alternates peak/valley; the multiplier varies
# how far each one travels.
MULT=(1.00 0.55 0.85 0.40 0.95 0.60 1.00 0.50 0.90 0.65 1.00 0.58)

# ridge <base-y-fraction> <amplitude-fraction> <segments>
ridge() {
  local base=$1 amp=$2 n=$3
  local pts="" i x y m
  for ((i = 0; i <= n; i++)); do
    x=$(( W * i / n ))
    m=${MULT[$(( i % ${#MULT[@]} ))]}
    if (( i % 2 == 0 )); then
      y=$(awk -v h="$H" -v b="$base" -v a="$amp" -v m="$m" 'BEGIN{printf "%d", h*(b + a*m)}')
    else
      y=$(awk -v h="$H" -v b="$base" -v a="$amp" -v m="$m" 'BEGIN{printf "%d", h*(b - a*m)}')
    fi
    pts+="$x,$y "
  done
  printf '%s%d,%d 0,%d' "$pts" "$W" "$H" "$H"
}

SUN_X=$(( W / 2 ))
SUN_Y=$(awk  -v h="$H" 'BEGIN{printf "%d", h*0.407}')
SUN_R=$(awk  -v h="$H" 'BEGIN{printf "%d", h*0.120}')
GLOW_R=$(awk -v h="$H" 'BEGIN{printf "%d", h*0.250}')
BLUR=$(awk   -v h="$H" 'BEGIN{printf "%d", h*0.065}')

# 1. sky — dark at the top, warming toward the horizon
magick -size ${W}x${H} gradient:'#1d2021-#504945' "$TMP/sky.png"

# 2. sun glow — a big soft bloom, screened over the sky
magick -size ${W}x${H} xc:black \
  -fill '#d79921' -draw "circle $SUN_X,$SUN_Y $SUN_X,$(( SUN_Y + GLOW_R ))" \
  -blur 0x$BLUR "$TMP/glow.png"
magick "$TMP/sky.png" "$TMP/glow.png" -compose screen -composite "$TMP/base.png"

# 3. sun disc, edge softened just enough to avoid aliasing
magick -size ${W}x${H} xc:none \
  -fill '#fabd2f' -draw "circle $SUN_X,$SUN_Y $SUN_X,$(( SUN_Y + SUN_R ))" \
  -blur 0x3 "$TMP/sun.png"
magick "$TMP/base.png" "$TMP/sun.png" -compose over -composite "$TMP/withsun.png"

# 4. three ridgelines, back to front, each darker than the last
magick "$TMP/withsun.png" \
  -fill '#665c54' -draw "polygon $(ridge 0.515 0.058 11)" \
  -fill '#3c3836' -draw "polygon $(ridge 0.650 0.050 9)"  \
  -fill '#282828' -draw "polygon $(ridge 0.800 0.042 7)"  \
  "$TMP/ridges.png"

# 5. vignette + a whisper of grain so a big panel doesn't band
magick "$TMP/ridges.png" \
  \( -size ${W}x${H} radial-gradient:'#00000000-#000000b0' \) \
  -compose over -composite \
  -attenuate 0.06 +noise Gaussian \
  -quality 95 "$OUT"

echo "wrote $OUT"
magick identify "$OUT"
