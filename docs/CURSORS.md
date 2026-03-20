# Cursor Theme: BreezeX-Dark

The desktop environment uses [BreezeX-Dark](https://github.com/ful1e5/BreezeX_Cursor), an extended KDE Breeze cursor theme.

## Installation

```bash
curl -L "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.1/BreezeX-Dark.tar.xz" -o /tmp/BreezeX-Dark.tar.xz
tar -xf /tmp/BreezeX-Dark.tar.xz -C /tmp/
mkdir -p ~/.icons
cp -r /tmp/BreezeX-Dark ~/.icons/
```

## Configuration

Set the theme in all relevant config locations:

**`~/.icons/default/index.theme`** — X11 default (create if it doesn't exist):
```ini
[icon theme]
Inherits=BreezeX-Dark
```

In this dotfiles repo, that file is tracked as `dot_icons/default/index.theme`.

**`~/.config/gtk-3.0/settings.ini`**:
```ini
gtk-cursor-theme-name=BreezeX-Dark
gtk-cursor-theme-size=48
```

**`~/.Xresources`**:
```
Xcursor.theme: BreezeX-Dark
Xcursor.size: 48
```

In this dotfiles repo, this is tracked as `dot_Xresources`.

**`~/.xprofile`** (session-wide X11 env/root cursor):
```bash
export XCURSOR_THEME="BreezeX-Dark"
export XCURSOR_SIZE="48"
export XCURSOR_PATH="$HOME/.icons:$HOME/.local/share/icons:/usr/share/icons"
xsetroot -cursor_name left_ptr
```

In this dotfiles repo, this is tracked as `dot_xprofile`.

**`~/.config/xsettingsd/xsettingsd.conf`** — enforces one cursor size/theme across toolkit apps:
```ini
Net/CursorThemeName "BreezeX-Dark"
Net/CursorThemeSize 48
Gtk/CursorThemeName "BreezeX-Dark"
Gtk/CursorThemeSize 48
```

In this dotfiles repo, this is tracked as `dot_config/xsettingsd/xsettingsd.conf`.

Then reload everything:
```bash
xrdb -merge ~/.Xresources
pkill xsettingsd; xsettingsd &
```

> `xsetroot` requires the `xorg-xsetroot` package.

A full logout/login is needed for all running applications to pick up the change.

## LightDM login screen cursor

LightDM greeter uses separate config from your user session:

**`/etc/lightdm/lightdm-gtk-greeter.conf.d/50-cursor.conf`**:
```ini
[greeter]
cursor-theme-name = BreezeX-Dark
cursor-theme-size = 48
```

In this dotfiles repo, that file is tracked as `dot_etc/lightdm/lightdm-gtk-greeter.conf.d/50-cursor.conf`.

System fallback for root/greeter contexts:

**`/usr/share/icons/default/index.theme`**:
```ini
[Icon Theme]
Inherits=BreezeX-Dark
```

In this dotfiles repo, that file is tracked as `dot_usr_share_icons/default/index.theme`.

## Deploy from repo

User/session files:
```bash
mkdir -p ~/.icons/default ~/.config/xsettingsd
cp -v dot_icons/default/index.theme ~/.icons/default/index.theme
cp -v dot_Xresources ~/.Xresources
cp -v dot_xprofile ~/.xprofile
cp -v dot_config/xsettingsd/xsettingsd.conf ~/.config/xsettingsd/xsettingsd.conf
chmod +x ~/.xprofile
```

System files (LightDM + system icon fallback):
```bash
sudo mkdir -p /etc/lightdm/lightdm-gtk-greeter.conf.d /usr/share/icons/default
sudo cp -v dot_etc/lightdm/lightdm-gtk-greeter.conf.d/50-cursor.conf /etc/lightdm/lightdm-gtk-greeter.conf.d/50-cursor.conf
sudo cp -v dot_usr_share_icons/default/index.theme /usr/share/icons/default/index.theme
```
