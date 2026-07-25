# Linux packages

Split by role so you can map them onto whatever distro you land on.
`shared/` needs the same CLI tools on both platforms — that list is identical
to what Homebrew installs on macOS.

## Wayland (preferred)

| Role | Package |
|---|---|
| compositor | `hyprland` |
| bar | `waybar` |
| wallpaper | `hyprpaper` (or `swaybg`) |
| launcher | `wofi` (or `rofi-wayland`) |
| notifications | `dunst` or `mako` |
| screenshot | `grim` + `slurp` |
| audio ctl | `wireplumber` (gives `wpctl`) |
| clipboard | `wl-clipboard` |
| portal | `xdg-desktop-portal-hyprland` |
| login manager | `ly` (see below) |

## X11 (fallback)

| Role | Package |
|---|---|
| wm | `i3-wm` |
| bar | `polybar` |
| wallpaper | `feh` |
| launcher | `rofi` |
| notifications | `dunst` |
| compositor (blur/shadows) | `picom` |
| screenshot | `maim` + `xclip` |
| audio ctl | `pulseaudio-utils` (gives `pactl`) |
| login manager | `ly` (see below) |

## Login manager — ly

Serves both stacks; it's a TUI on a tty, so it doesn't care which one you boot
into. Packaged on some distros (Arch: `ly`), absent on others (Debian/Ubuntu) —
there, build it from source with Zig 0.16.x. Enable command, config path, and
the gruvbox values for `/etc/ly/config.ini` are in **CLAUDE.md §5**; that config
is root-owned, so `install.sh` cannot symlink it and it must be applied by hand.

## Shared — same on macOS and Linux

```
ghostty tmux vim zsh
starship zoxide fzf eza bat ripgrep fd
btop fastfetch yazi lazygit jq git
```

Font: **Iosevka Nerd Font** — required, it's what draws the powerline arrows.

```
# Arch
paru -S ttf-iosevka-nerd
# Debian/Ubuntu — install manually
mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Iosevka.zip
unzip -o Iosevka.zip && fc-cache -fv
```

## Distro quick-starts

```bash
# Arch — Wayland
sudo pacman -S hyprland waybar hyprpaper wofi dunst grim slurp wl-clipboard \
               xdg-desktop-portal-hyprland ghostty tmux vim zsh starship \
               zoxide fzf eza bat ripgrep fd btop fastfetch yazi lazygit jq

# Fedora — X11
sudo dnf install i3 polybar feh rofi dunst picom maim xclip \
                 tmux vim zsh zoxide fzf eza bat ripgrep fd btop jq
```

## After installing

```bash
git clone <this repo> ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh --dry-run     # check what it'll touch
./install.sh
```

Then regenerate the wallpaper for your panel — edit `W`/`H` at the top of
`wallpaper/make_wallpaper.sh` and run it. Requires ImageMagick 7 (`magick`).
