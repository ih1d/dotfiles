#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  gruvbox rice — installer
#
#    ./install.sh            symlink everything for this OS
#    ./install.sh --dry-run  print what it would do
#    ./install.sh --unlink   remove the symlinks, restore backups
#
#  Every file it replaces is moved to  ~/.dotfiles-backup/<stamp>/
#  first, so this is always reversible.
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

DOTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/.dotfiles-backup/$STAMP"
DRY=0; UNLINK=0

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY=1 ;;
    --unlink)  UNLINK=1 ;;
    *) echo "unknown flag: $arg"; exit 1 ;;
  esac
done

case "$(uname -s)" in
  Darwin) OS=macos ;;
  Linux)  OS=linux ;;
  *) echo "unsupported OS: $(uname -s)"; exit 1 ;;
esac

say()  { printf '  %s\n' "$*"; }
head_() { printf '\n\033[1;33m%s\033[0m\n' "$*"; }

# link <src-relative-to-DOTS> <dest-absolute>
link() {
  local src="$DOTS/$1" dest="$2"

  [ -e "$src" ] || { say "skip (no source): $1"; return; }

  if [ "$UNLINK" = 1 ]; then
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
      [ "$DRY" = 1 ] || rm "$dest"
      say "unlinked $dest"
    fi
    return
  fi

  # already correct?
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    say "ok       $dest"
    return
  fi

  if [ "$DRY" = 1 ]; then
    say "would link $dest -> $1"
    return
  fi

  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP/$(dirname "${dest#$HOME/}")"
    mv "$dest" "$BACKUP/${dest#$HOME/}"
    say "backed up $dest"
  fi
  ln -s "$src" "$dest"
  say "linked   $dest -> $1"
}

head_ "gruvbox rice → $OS"
[ "$DRY" = 1 ] && say "(dry run — nothing will change)"

# ── shared ─────────────────────────────────────────────────────
head_ "shared"
link shared/starship/starship.toml  "$HOME/.config/starship.toml"
link shared/tmux/tmux.conf          "$HOME/.tmux.conf"
link shared/bat/config              "$HOME/.config/bat/config"
link shared/lazygit/config.yml      "$HOME/.config/lazygit/config.yml"
link shared/yazi/theme.toml         "$HOME/.config/yazi/theme.toml"
link shared/fastfetch/config.jsonc  "$HOME/.config/fastfetch/config.jsonc"
link shared/btop/btop.conf          "$HOME/.config/btop/btop.conf"
link shared/vim/vimrc               "$HOME/.vimrc"
link shared/vim/autoload/airline/themes/gruvbox_rice.vim \
                                    "$HOME/.vim/autoload/airline/themes/gruvbox_rice.vim"

# ── zsh: source the rice block rather than clobbering .zshrc ────
RICE_LINE="[ -f \"$DOTS/shared/zsh/zshrc.rice\" ] && source \"$DOTS/shared/zsh/zshrc.rice\""
if [ "$UNLINK" = 1 ]; then
  if [ -f "$HOME/.zshrc" ] && grep -qF "zshrc.rice" "$HOME/.zshrc"; then
    [ "$DRY" = 1 ] || { grep -vF "zshrc.rice" "$HOME/.zshrc" > "$HOME/.zshrc.tmp" && mv "$HOME/.zshrc.tmp" "$HOME/.zshrc"; }
    say "removed rice source line from .zshrc"
  fi
elif grep -qF "zshrc.rice" "$HOME/.zshrc" 2>/dev/null; then
  say "ok       .zshrc already sources the rice"
else
  [ "$DRY" = 1 ] || printf '\n# gruvbox rice\n%s\n' "$RICE_LINE" >> "$HOME/.zshrc"
  say "appended rice source line to .zshrc"
fi

# ── per-OS ─────────────────────────────────────────────────────
if [ "$OS" = macos ]; then
  head_ "macos"
  link macos/aerospace/aerospace.toml "$HOME/.config/aerospace/aerospace.toml"
  link macos/borders/bordersrc        "$HOME/.config/borders/bordersrc"
  link macos/sketchybar/sketchybarrc  "$HOME/.config/sketchybar/sketchybarrc"
  link macos/sketchybar/colors.sh     "$HOME/.config/sketchybar/colors.sh"
  for p in "$DOTS"/macos/sketchybar/plugins/*.sh; do
    link "macos/sketchybar/plugins/$(basename "$p")" \
         "$HOME/.config/sketchybar/plugins/$(basename "$p")"
  done
  link macos/ghostty/themes/gruvbox-dark-rice \
       "$HOME/.config/ghostty/themes/gruvbox-dark-rice"
  link macos/ghostty/config \
       "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
  [ "$UNLINK" = 1 ] || [ "$DRY" = 1 ] || chmod +x "$HOME/.config/sketchybar/sketchybarrc" \
        "$HOME/.config/sketchybar/plugins/"*.sh "$HOME/.config/borders/bordersrc" 2>/dev/null || true
else
  head_ "linux"
  link linux/hypr/hyprland.conf   "$HOME/.config/hypr/hyprland.conf"
  link linux/waybar/config.jsonc  "$HOME/.config/waybar/config.jsonc"
  link linux/waybar/style.css     "$HOME/.config/waybar/style.css"
  link linux/i3/config            "$HOME/.config/i3/config"
  link linux/polybar/config.ini   "$HOME/.config/polybar/config.ini"
  link linux/ghostty/config       "$HOME/.config/ghostty/config"
  link macos/ghostty/themes/gruvbox-dark-rice \
       "$HOME/.config/ghostty/themes/gruvbox-dark-rice"
fi

# ── wallpaper ──────────────────────────────────────────────────
if [ "$UNLINK" != 1 ] && [ "$DRY" != 1 ]; then
  head_ "wallpaper"
  mkdir -p "$HOME/Pictures/Wallpapers"
  cp -n "$DOTS/wallpaper/gruvbox-ridge.png" "$HOME/Pictures/Wallpapers/" 2>/dev/null || true
  say "$HOME/Pictures/Wallpapers/gruvbox-ridge.png"
fi

head_ "done"
[ -d "$BACKUP" ] && say "backups: $BACKUP"
say "macOS : run  ./macos/defaults.sh   then grant AeroSpace Accessibility"
say "linux : see  CLAUDE.md § Porting to Linux"
