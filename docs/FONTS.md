# Font Configuration

This document describes the font setup for the bspwm desktop environment.

## Primary Font: Noto Sans Mono

**Noto Sans Mono** is configured as the default monospace font system-wide.

### Installation

**Arch/Manjaro:**
```bash
sudo pacman -S noto-fonts
```

**Ubuntu/Debian:**
```bash
sudo apt install fonts-noto
```

### Automated Setup

Run the setup script:
```bash
./scripts/setup-noto-fonts.sh
```

### Manual Configuration

The script configures these files:

#### 1. Fontconfig (`~/.config/fontconfig/fonts.conf`)
Sets Noto Sans Mono as default for `monospace`, `mono`, and `courier` font families.

#### 2. GTK Applications
- **GTK 2.0** (`~/.gtkrc-2.0`): `gtk-font-name="Noto Sans Mono 11"`
- **GTK 3.0** (`~/.config/gtk-3.0/settings.ini`): `gtk-font-name=Noto Sans Mono 11`
- **GTK 4.0** (`~/.config/gtk-4.0/settings.ini`): `gtk-font-name=Noto Sans Mono 11`

#### 3. Application-Specific

**Emacs** (`~/.emacs`):
```elisp
;; Frame and font settings
(add-to-list 'default-frame-alist '(font . "Noto Sans Mono-16"))

;; Set default face for all UI elements
(set-face-attribute 'default nil :font "Noto Sans Mono-16")
```

**Alacritty** (`~/.config/alacritty/alacritty.toml`):
```toml
[font]
normal = {family = "NotoSansMono", style="Regular"}
size = 12
```

### Font Verification

Check that Noto Sans Mono is the default monospace font:
```bash
fc-match monospace
# Should output: NotoSansMono-Regular.ttf: "Noto Sans Mono" "Regular"
```

List all Noto Sans Mono variants available:
```bash
fc-list | grep -i "noto sans mono"
```

### Applications Using This Font

- **Emacs**: Code editing, UI elements
- **Alacritty**: Terminal emulator
- **Thunar**: File manager (directory listings)
- **Rofi**: Application launcher
- **Text editors**: Any editor that respects system monospace font
- **Code applications**: IDEs, terminals that use fontconfig

### Troubleshooting

**Font not applied:**
1. Restart applications
2. Log out and back in
3. Check `fc-match monospace` output

**Different font sizes:**
- Emacs uses size 16
- Alacritty uses size 12 (default)
- GTK apps use size 11
- Adjust per application as needed

**Missing font:**
Ensure noto-fonts package is installed for your distribution.

### Font Characteristics

**Noto Sans Mono** features:
- Monospaced (fixed-width)
- Clean, modern appearance
- Excellent Unicode coverage
- Good for code and terminal use
- Designed by Google for readability

### Alternative Fonts

If Noto Sans Mono isn't available, fallbacks in order:
1. DejaVu Sans Mono
2. Liberation Mono
3. Courier New
4. System default monospace

To change to a different font, modify the fontconfig and application configs accordingly.