# gruvbox rice

A Gruvbox Dark desktop, tiled and keyboard-driven. Live on macOS 26 (Apple
Silicon); Linux configs included so the same setup ports to Wayland or X11.

```
┌─────────────────────────────────────────────────────────────┐
│  1 2 3 4 5 6 7 8 9  │  Ghostty      󰍛 37%   9%  󰁹 100%  16:22│  sketchybar
├──────────────────────────────┬──────────────────────────────┤
│                              │                              │
│           Firefox            │           Ghostty            │  aerospace
│                              │      ╰ tmux ╰ vim ╰ zsh      │
└──────────────────────────────┴──────────────────────────────┘
```

## What's in it

| | macOS | Linux |
|---|---|---|
| window manager | AeroSpace | Hyprland / i3 |
| status bar | SketchyBar | Waybar / Polybar |
| window borders | JankyBorders | built into the WM |
| terminal | Ghostty | Ghostty |
| prompt | Starship (full-width bar) | same |
| multiplexer | tmux | same |
| editor | vim + custom airline theme | same |
| tools | btop · yazi · lazygit · fzf · eza · bat · fastfetch | same |

Four bars — sketchybar, tmux, starship, airline — all share one palette,
one accent (`#fabd2f`), and one set of powerline separators.

## Install

```bash
git clone <repo> ~/Projects/dotfiles
cd ~/Projects/dotfiles

./install.sh --dry-run     # see what it would touch
./install.sh               # symlink it all (backs up whatever it replaces)
```

**macOS**, additionally:

```bash
brew install --cask nikitabobko/tap/aerospace font-sketchybar-app-font
brew install FelixKratz/formulae/sketchybar FelixKratz/formulae/borders \
             starship fastfetch eza bat zoxide jq

./macos/defaults.sh        # dock, menu bar, accent colour, wallpaper
```

Then grant **AeroSpace** Accessibility permission in System Settings →
Privacy & Security → Accessibility, or it will run but ignore every keybind.

**Linux**: see [`linux/packages.md`](linux/packages.md).

## Keys

Modifier is `alt` everywhere.

```
alt+enter          terminal          alt+1..9         workspace N
alt+h/j/k/l        focus             alt+shift+1..9   move to workspace N
alt+shift+hjkl     move window       alt+tab          last workspace
alt+shift+f        fullscreen        alt+-  alt+=     resize
alt+shift+space    float             alt+/            split direction
alt+shift+b        browser           alt+,            accordion
alt+shift+;        service mode  →  esc reload · r reset · ⌫ close others
```

`alt+b` and `alt+f` are left free on purpose — readline needs them for
backward-word / forward-word.

## Undo

```bash
./install.sh --unlink     # remove symlinks, restore what was backed up
./macos/defaults.sh revert # dock, menu bar, accent colour
```

Backups land in `~/.dotfiles-backup/<timestamp>/`.

## Wallpaper

```bash
W=2560 H=1440 ./wallpaper/make_wallpaper.sh
```

Generated with ImageMagick from the same palette — no binary blob to trust.

---

See [`CLAUDE.md`](CLAUDE.md) for the design contract, the porting map, and the
gotchas hit while building this.
