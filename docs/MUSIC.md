# MPD and ncmpcpp Setup Guide

This document describes the setup and usage of MPD (Music Player Daemon) and ncmpcpp for music playback, integrated with polybar.

## What We Installed

```bash
sudo pacman -S mpd mpc ncmpcpp
```

- **MPD** - Music Player Daemon (background music server)
- **mpc** - Command-line MPD client
- **ncmpcpp** - Terminal-based MPD client with full interface

## Configuration Files Created

### MPD Configuration: `~/.config/mpd/mpd.conf`

```ini
# MPD Configuration File

# Paths
music_directory		"~/Music"
playlist_directory	"~/.local/share/mpd/playlists"
db_file			"~/.local/share/mpd/database"
log_file		"~/.local/share/mpd/log"
pid_file		"~/.local/share/mpd/pid"
state_file		"~/.local/share/mpd/state"
sticker_file		"~/.local/share/mpd/sticker.sql"

# Network
bind_to_address		"localhost"
port			"6600"

# Audio Output
audio_output {
	type		"pulse"
	name		"PulseAudio Output"
}

# Optional: FIFO output for visualizers
audio_output {
	type		"fifo"
	name		"FIFO Output"
	path		"/tmp/mpd.fifo"
	format		"44100:16:2"
}

# Settings
user			"will"
auto_update		"yes"
follow_outside_symlinks	"yes"
follow_inside_symlinks	"yes"
```

### Directories Created

```bash
mkdir -p ~/.config/mpd
mkdir -p ~/.local/share/mpd
mkdir -p ~/.local/share/mpd/playlists
```

## Initial Setup Commands

1. **Start MPD:**
   ```bash
   mpd ~/.config/mpd/mpd.conf
   ```

2. **Update music database:**
   ```bash
   mpc update
   ```

3. **Verify setup:**
   ```bash
   mpc status
   mpc listall | head -10
   ```

## Daily Usage

### Primary Music Player Interface

```bash
ncmpcpp
```

**ncmpcpp Navigation:**
- `1-8` = Switch between different screens (library, playlists, etc.)
- `Enter` = Play selected track
- `Space` = Pause/unpause
- `>` = Next track
- `<` = Previous track
- `q` = Quit

### Quick Command-Line Control

```bash
mpc play        # Resume playback
mpc pause       # Pause
mpc next        # Next track
mpc prev        # Previous track
mpc stop        # Stop playback
mpc random      # Toggle random mode
mpc repeat      # Toggle repeat mode
```

### Adding Music to Queue

```bash
mpc add "Artist Name"           # Add all songs by artist
mpc add "Artist/Album"          # Add specific album
mpc add "path/to/song.mp3"      # Add specific song
```

## Polybar Integration

The polybar "shapes" configuration includes an MPD module that automatically displays:
- Current artist and track name
- Playback controls (when clicked)
- Connection status

**Module location:** `~/.config/polybar/shapes/modules.ini` (lines 661-751)

## Auto-Start on Login (Optional)

To automatically start MPD when you log in:

```bash
systemctl --user enable mpd
systemctl --user start mpd
```

## Troubleshooting

**If MPD isn't found:**
- Make sure it's installed: `pacman -Q mpd`
- Check if it's running: `pgrep mpd`

**If no music appears:**
- Update database: `mpc update`
- Check music directory path in config
- Verify file permissions

**If polybar doesn't show music:**
- Ensure MPD is running on port 6600
- Check polybar logs: `polybar main 2>&1 | grep mpd`

## Music Collection Stats

- **Total tracks found:** ~565 songs
- **Music directory:** `~/Music/`
- **Database location:** `~/.local/share/mpd/database`

---

*Setup completed on July 31, 2025*