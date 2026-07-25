# gruvbox rice — project guide

A cross-platform desktop rice built around **Gruvbox Dark**. It is currently
live on macOS 26 (Tahoe, Apple Silicon). The Linux half exists so the same
setup can be reproduced on a Linux box without redesigning anything.

**The rule that governs this repo: the *look* and the *keybindings* are the
product. The tools are interchangeable.** When porting, keep the contract in
§2 and §3 identical; swap whatever software is needed to hit it.

---

## 1. Repo layout

```
palette.sh              ← single source of truth for every colour
install.sh              ← symlinks configs into place, OS-aware, reversible
CLAUDE.md               ← you are here
README.md               ← human-facing quickstart

macos/                  ← macOS-only stack
  aerospace/            window manager
  sketchybar/           status bar (+ plugins/ = one script per bar item)
  borders/              JankyBorders — focused-window outline
  ghostty/              terminal config + colour theme
  defaults.sh           dock / menu bar / accent / wallpaper; has a revert()

linux/                  ← Linux equivalents (Wayland + X11 paths)
  hypr/                 Hyprland   (Wayland compositor — preferred)
  waybar/               Waybar     (bar for Hyprland/sway)
  i3/                   i3         (X11 fallback)
  polybar/              Polybar    (bar for i3)
  ghostty/              same terminal, different config path

shared/                 ← identical on both platforms
  zsh/zshrc.rice        shell layer, sourced from ~/.zshrc (never overwrites it)
  starship/             prompt — full-width bar
  vim/                  .vimrc + custom vim-airline theme
  tmux/                 tmux status bar
  bat/ btop/ yazi/ lazygit/ fastfetch/

wallpaper/
  gruvbox-ridge.png     3840×2160
  make_wallpaper.sh     regenerates it with ImageMagick at any resolution
```

`install.sh` symlinks — it never copies configs into place. Editing
`~/.config/aerospace/aerospace.toml` edits the file in this repo. That is
intentional; there is no "sync back" step to forget.

---

## 2. The visual contract

Every colour comes from `palette.sh`. **Never hardcode a hex that isn't in
that file.** When adding a tool, map it to a *semantic role*, not a raw hex:

| Role | Hex | Used for |
|---|---|---|
| `GB_BASE` | `#1d2021` | bar background, terminal background, wallpaper base |
| `GB_SURFACE` | `#3c3836` | bar border, unfocused window border, prompt bar fill |
| `GB_CHIP` | `#504945` | a raised element sitting on a bar |
| `GB_TEXT` | `#ebdbb2` | default text |
| `GB_MUTED` | `#928374` | inactive workspaces, hints, disabled |
| **`GB_ACCENT`** | **`#fabd2f`** | **focused window border, active workspace, prompt caret, vim normal mode** |
| `GB_OK` | `#b8bb26` | battery healthy, git clean, insert-adjacent states |
| `GB_WARN` | `#fe8019` | load 50–80%, battery 10–30%, modified buffer, visual mode |
| `GB_CRIT` | `#fb4934` | load >80%, battery <10%, errors, replace mode |
| `GB_INFO` | `#83a598` | CPU metric, paths, vim insert mode |
| `GB_ALT` | `#d3869b` | RAM metric, secondary metric |

Geometry and typography, held constant across platforms:

- **Font:** Iosevka Nerd Font everywhere. The Nerd Font patch is required —
  the powerline arrows (``  ``  ``  ``) and glyphs depend on it.
- **Gaps:** 8px inner, 8px outer, **50px top** (the bar lives there).
- **Bar:** 36px tall, floating (8px side margin, 6px from top), 10px corner
  radius, 2px `GB_SURFACE` border, translucent `GB_BASE`.
- **Window border:** 5px, rounded, `GB_ACCENT` focused / `GB_SURFACE` not.
- **Terminal:** 92% opacity + blur, 14px font, 14/12 padding.

Four bars stack vertically and must look like one system: sketchybar (top of
screen) → tmux status (top of terminal) → starship prompt → vim airline. Same
palette, same accent, same separator glyphs.

---

## 3. The keybinding contract

**This is the part that must survive a port.** Modifier is `alt` on both
platforms (on macOS, `alt` = Option; Ghostty sets `macos-option-as-alt`).

| Keys | Action |
|---|---|
| `alt+h/j/k/l` | focus window left/down/up/right |
| `alt+shift+h/j/k/l` | move window |
| `alt+ctrl+shift+h/j/k/l` | join window into that neighbour's container |
| `alt+1..9` | switch to workspace N |
| `alt+shift+1..9` | move window to workspace N |
| `alt+tab` | last workspace |
| `alt+enter` | new terminal |
| `alt+b` | browser (Zen) |
| `alt+x` | close window (`alt+shift+q` kept as an alias) |
| `alt+shift+f` | fullscreen |
| `alt+shift+space` | toggle floating |
| `alt+-` / `alt+=` | resize |
| `alt+/` | toggle tiles horizontal↔vertical |
| `alt+,` | toggle accordion/stacked |
| `alt+shift+;` | enter service mode (then `esc` reload · `r` reset tree · `backspace` close others) |

`alt+f` is **deliberately left unbound** — readline uses it for forward-word in
the terminal. Do not claim it.

`alt+b` was previously held free for readline's backward-word and is now the
browser key by explicit choice. The cost is real and accepted: the WM grabs the
chord globally, so backward-word is no longer reachable inside a terminal. If
you want it back, `ctrl+[` then `b` is the readline equivalent (`ESC b`).

---

## 4. macOS stack (current, working)

| Layer | Tool | Notes |
|---|---|---|
| WM | **AeroSpace** | Chosen over yabai specifically because it needs **no SIP changes**. It uses its own virtual workspaces rather than macOS Spaces. Do not migrate to yabai without asking — that requires disabling SIP from recovery mode. |
| Bar | **SketchyBar** | `sketchybarrc` defines items; each item's `script=` points at `plugins/<name>.sh`, which reads `$NAME`/`$SENDER`/`$INFO` from the environment and calls `sketchybar --set`. |
| Borders | **JankyBorders** | Standalone daemon, launched by AeroSpace. |
| Terminal | **Ghostty** | Config lives at `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty` on this machine, **not** `~/.config/ghostty/config`. Themes still resolve from `~/.config/ghostty/themes/`. |

AeroSpace's `after-startup-command` launches borders and sketchybar, so
AeroSpace owns their lifecycle — do not also register them as brew services or
they will double-start (sketchybar will refuse with a lock-file error).

Workspace→bar wiring: `exec-on-workspace-change` in `aerospace.toml` fires
`sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=...`, which
each `space.N` item is subscribed to.

---

## 5. Porting to Linux

Pick Wayland (preferred) or X11, then map one-for-one. Everything in
`shared/` transfers untouched.

| macOS | Wayland | X11 |
|---|---|---|
| AeroSpace | **Hyprland** (or sway) | **i3** |
| SketchyBar | **Waybar** | **Polybar** |
| JankyBorders | built into Hyprland (`general:col.active_border`) | i3 `client.focused` |
| `defaults.sh` | `hyprpaper` / `swaybg` | `feh --bg-fill` |
| Ghostty (App Support path) | Ghostty at `~/.config/ghostty/config` | same |
| `pmset -g batt` | `/sys/class/power_supply/BAT0/capacity` | same |
| `memory_pressure` | `free` or `/proc/meminfo` | same |
| `ps -A -o %cpu` | `/proc/stat` delta | same |
| `osascript` volume | `wpctl get-volume @DEFAULT_AUDIO_SINK@` | `pactl` |
| macOS `loginwindow` (not themeable) | **ly** | same |

### Doing the port

1. `./install.sh` on the Linux box — it detects `uname -s` and links the
   `linux/` tree instead of `macos/`.
2. Install the packages listed in `linux/packages.md`.
3. Regenerate the wallpaper at the target resolution:
   `W=2560 H=1440 ./wallpaper/make_wallpaper.sh` (edit `W`/`H` at the top).
4. Set up the login screen by hand — see below. `install.sh` cannot do it.
5. Verify against §2 and §3 — same gaps, same accent, same keys.

### Login screen — ly

**ly** is a TUI display manager that runs on a bare tty, so it needs no X/Wayland
session of its own and works for both the Hyprland and i3 halves of this rice.

It is the one piece of the setup `install.sh` does **not** manage: its config is
root-owned at `/etc/ly/config.ini`, outside `$HOME`, and this repo only ever
symlinks into `$HOME`. The values below are the source of truth; apply them by
hand and re-apply them after an upgrade that overwrites the config.

Upstream is <https://codeberg.org/fairyglade/ly> (GitHub `fairyglade/ly` mirrors
it). It builds with Zig 0.16.x:

```sh
git clone https://codeberg.org/fairyglade/ly.git
cd ly && zig build
sudo zig build installexe -Dinit_system=systemd   # `installnoconf` preserves an existing config
```

Enable it, and take tty2 away from getty or the two fight over the same tty:

```sh
sudo systemctl enable ly@tty2.service
sudo systemctl disable getty@tty2.service
```

The §2 palette in ly's own format — `0xSSRRGGBB`, where the leading byte is a
style flag (`0x01` = bold). `full_color = true` must stay on or these collapse
to the 16-colour console palette:

| Key | Value | Role |
|---|---|---|
| `bg` | `0x001d2021` | `GB_BASE` |
| `fg` | `0x00ebdbb2` | `GB_TEXT` |
| `border_fg` | `0x00fabd2f` | `GB_ACCENT` |
| `error_bg` | `0x001d2021` | `GB_BASE` |
| `error_fg` | `0x01fb4934` | `GB_CRIT`, bold |

Keep `animation = none`. The bundled animations (`doom`, `matrix`, `colormix`,
`gameoflife`) each carry their own hardcoded palette and none of them is gruvbox.

Two parts of §2 genuinely do not reach ly, and should not be faked: it renders in
the **console font**, not Iosevka Nerd Font, so there are no powerline glyphs;
and it has no gaps or corner radii, only `box_position_h`/`box_position_v` and
`margin_box_h`/`margin_box_v`.

### Things that genuinely have no macOS equivalent, and are therefore free wins

Hyprland gives you real animations, blur, and per-window rules that AeroSpace
cannot do. Use them — but keep the *palette* and *geometry* from §2. A
blurred, animated gruvbox rice is still the same rice.

### Things that will NOT port and should be dropped, not emulated

- `macos/defaults.sh` in its entirety (Dock, menu bar, `AppleAccentColor`).
- Ghostty's `macos-titlebar-style` / `macos-option-as-alt` keys.
- `sketchybar`'s `front_app` item depends on the macOS front-app event; on
  Waybar use `hyprland/window` instead.

---

## 6. Conventions when editing this repo

- **Colour changes start in `palette.sh`**, then propagate outward. Grep for
  the old hex before declaring the change done — the palette is duplicated
  into each tool's native format (`0xAARRGGBB` for sketchybar/borders, `#rrggbb`
  for everything else) because none of them can read a shared file.
- **Bar items are one script each.** Adding a metric to sketchybar means a new
  `plugins/<name>.sh` plus an `--add item` block; don't inline logic in
  `sketchybarrc`.
- **Never overwrite `~/.zshrc`.** The shell layer lives in
  `shared/zsh/zshrc.rice` and is sourced by one appended line.
- **Test before claiming success.** Concretely:
  - `aerospace list-workspaces --all` — WM is responsive
  - `sketchybar --query <item> | jq` — the bar item actually has a value
  - `starship prompt --status=0 | cat -v` — prompt renders, no missing modules
  - `vim -c 'echo g:airline_theme' -c 'qa!'` — airline theme resolved
  - `tmux source-file ~/.tmux.conf` — no parse errors

---

## 7. Gotchas hit on this machine

- **Plan 9 from User Space breaks Homebrew.** `/usr/local/plan9/bin` is on
  `PATH` and its `tar` doesn't understand GNU flags, so `brew install` dies
  with `tar: unknown letter e`. `shared/zsh/zshrc.rice` ships a `brew()`
  wrapper that strips `*/plan9/bin` from `PATH` for that one command. If a
  brew install fails oddly, check this first.
- **AeroSpace needs Accessibility permission** (System Settings → Privacy &
  Security → Accessibility) on first launch, or it starts but never answers
  `aerospace` CLI calls.
- **Screenshots from a terminal need Screen Recording permission**, otherwise
  `screencapture` returns "could not create image from display". Verify the
  bar with `sketchybar --query` instead.
- **`vim-airline-themes` ships no plain `gruvbox` theme** — only `base16_*`
  variants. That's why `shared/vim/autoload/airline/themes/gruvbox_rice.vim`
  is hand-written. It lives under `~/.vim/autoload/`, not in the plugin
  directory, so `:PlugUpdate` can't clobber it.
- **`tmuxline.vim` will rewrite the tmux status bar** from airline's theme the
  moment vim starts. It's disabled
  (`g:airline#extensions#tmuxline#enabled = 0`) so `shared/tmux/tmux.conf`
  stays authoritative. Leave it off.
