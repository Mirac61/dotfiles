# Miracs Dotfiles

Meine macOS-Entwicklungsumgebung und System-Konfiguration für **Neovim**, **tmux**, **Zellij**, **AeroSpace** und **SketchyBar** – verwaltet über ein zentrales `install.sh`-Skript (kompatibel mit GNU Stow und direkten Symlinks).

![Neovim-Dashboard](docs/images/neovim-dashboard.png)

## Inhalt

| Ordner       | Zielpfad                  | Beschreibung                                                                 |
| ------------ | ------------------------- | ---------------------------------------------------------------------------- |
| `nvim`       | `~/.config/nvim`          | Neovim-Konfiguration mit `lazy.nvim`, Snacks, `blink.cmp`, Mason & Pixel-Art |
| `tmux`       | `~/.config/tmux`          | tmux-Konfiguration mit Ukiyo-Statusleiste und interaktivem Theme-Menü        |
| `zellij`     | `~/.config/zellij`        | Zellij Terminal-Multiplexer Konfiguration (`config.kdl`)                     |
| `aerospace`  | `~/.aerospace.toml`       | AeroSpace Tiling Window Manager Konfiguration (`ctrl+alt` Keybindings)       |
| `sketchybar` | `~/.config/sketchybar`    | Minimalistische macOS Statusbar mit interaktiven Popups & Theme-Switcher     |
| `tools`      | –                         | Generator für die Neovim-Dashboard-Motive                                    |

---

## Schnellstart (Automatische Installation)

Über das mitgelieferte `install.sh`-Skript werden vorhandene Konfigurationen automatisch unter `~/.dotfiles-backup/` gesichert, alle Symlinks eingerichtet und auf Wunsch alle benötigten Homebrew-Pakete installiert:

```sh
git clone https://github.com/Mirac61/nvim-config.git ~/dotfiles
cd ~/dotfiles

# Interaktive Installation (fragt nach Homebrew-Paketen & setzt alle Symlinks)
./install.sh

# Oder direkt nur alle Symlinks setzen (ohne Paket-Abfrage):
./install.sh --link-only

# Oder nur einzelne Module verlinken:
./install.sh nvim zellij aerospace sketchybar
```

Alternativ kann jedes Modul auch einzeln mit **GNU Stow** verlinkt werden:

```sh
stow --target="$HOME" nvim tmux zellij aerospace sketchybar
```

---

## SketchyBar

Minimalistische, schnelle macOS-Statusleiste passend zu AeroSpace:

- **`⌘`-Menü (oben links):** Direktes Umschalten zwischen Stilen (`Minimal Tint`, `Floating Glass`, `Split Capsules`) und Farbschemata (`Kanagawa Dragon`, `macOS Glass`, `Catppuccin Mocha`, `Tokyo Night`, `Rosé Pine Moon`) sowie Schnellzugriff auf `config.sh`.
- **Interaktive Popups:** Klick auf **WLAN** (IP kopieren, WLAN an/aus, Einstellungen), **Batterie** (Restlaufzeit & Stromquelle) oder **Kalender** (Wochenübersicht, Datum kopieren, Kalender-App).
- **CLI-Switcher:** `~/.config/sketchybar/switch_style.sh` zum Wechseln per Terminal.

---

## AeroSpace

Tiling Window Manager mit `ctrl+alt` als Haupt-Modifier (kollidiert nicht mit deutschen Sonderzeichen auf `alt`):

- `ctrl+alt+1..5` / `T` (Terminal) / `B` (Browser) / `N` (Notizen): Workspace wechseln
- `ctrl+alt+shift+1..5/T/B/N`: Fenster auf Workspace verschieben
- `ctrl+alt+h/j/k/l`: Fokus wechseln
- `ctrl+alt+enter`: Neues Ghostty-Fenster öffnen

---

## Neovim

Die Leader-Taste ist `Space`. Plugins liegen in `lua/plugins/`, eigene Tasten in
`lua/config/keymaps.lua`. Die Versionen sind in `lazy-lock.json` festgehalten.

| Taste        | Aktion                        |
| ------------ | ----------------------------- |
| `<leader>e`  | Datei-Explorer                |
| `<leader>ff` | Dateien suchen                |
| `<leader>fw` | Im Projekt suchen (Grep)      |
| `<leader>fb` | Offene Buffer                 |
| `<leader>fk` | Alle Tastenkürzel durchsuchen |
| `jk`         | Insert-Modus verlassen        |

Language Server (unter anderem `gopls`, `clangd`, `lua_ls`, `marksman`) werden
über Mason installiert. Zum Formatieren dient `conform.nvim`.

---

## tmux & Zellij

- **tmux:** Die Statusleiste liegt oben und nutzt das Plugin Ukiyo. Mit `prefix + T` öffnet sich das Theme-Menü (Vercel, Kanagawa, Tokyo Night, Nord, Gruvbox).
- **Zellij:** Konfiguriert in `zellij/.config/zellij/config.kdl` mit angepassten Keybindings und Theme-Support.

---

## Dashboard-Motive (Neovim)

Es gibt zwölf Motive im japanischen Nacht- und Schrein-Stil: Mond, Koi, Torii,
Pagode, Kirschblüten- und Gedenklaternen, Katzen, Higanbana, Bambuswald mit
Glühwürmchen, Kitsune-Maske und Samurai.

```sh
python3 -m pip install Pillow
python3 tools/dashboard_art_gen.py
```
