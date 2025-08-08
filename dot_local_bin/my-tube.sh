#!/bin/bash

# List of channels to download from — add or remove as needed
CHANNELS=(
  "https://www.youtube.com/@TechLead"
  "https://www.youtube.com/@Computerphile"
  "https://www.youtube.com/@3blue1brown"
  "https://www.youtube.com/@smartereveryday"
  "https://www.youtube.com/@DiscGolfProTour"
  "https://www.youtube.com/@thediscgolfworld"
  "https://www.youtube.com/@aldenharris18"
  "https://www.youtube.com/@Fireship"
  "https://www.youtube.com/@FrontendMasters"
  "https://www.youtube.com/@SimonLizotte8332"
  "https://www.youtube.com/@influxdata8893"
  "https://www.youtube.com/@jherr"
  "https://www.youtube.com/@JomezPro"
  "https://www.youtube.com/@NetNinja"
  "https://www.youtube.com/@syntaxfm"
  "https://www.youtube.com/@kleintexasstake9092/streams"
  "https://www.youtube.com/@nprmusic"
  "https://www.youtube.com/@TeachingwithPower"
  "https://www.youtube.com/@talkingscripture"
  "https://www.youtube.com/@BodanzaDiscGolf"
  "https://www.youtube.com/@fxevolutionvideo"
  "https://www.youtube.com/@WebDevCody"
  "https://www.youtube.com/@EzraAderholdDG"
  "https://www.youtube.com/@passionproduction"
  "https://www.youtube.com/@aarongossage3787"
  "https://www.youtube.com/@churchofjesuschrist"
)

# Set base output and archive directories
BASE_DIR="$HOME/Videos/YT"
ARCHIVE_DIR="$HOME/.yt-archives"

mkdir -p "$BASE_DIR"
mkdir -p "$ARCHIVE_DIR"

# Loop through each channel
for CHANNEL in "${CHANNELS[@]}"; do
  # Extract a simple name from the URL for folder and archive naming
  NAME=$(echo "$CHANNEL" | awk -F'@' '{print $2}')
  CHANNEL_DIR="$BASE_DIR/$NAME"
  ARCHIVE_FILE="$ARCHIVE_DIR/$NAME.txt"

  echo "🔽 Downloading latest 2 videos from $CHANNEL..."

  mkdir -p "$CHANNEL_DIR"

  yt-dlp "$CHANNEL" \
  --playlist-end 2 \
  --download-archive "$ARCHIVE_FILE" \
  -f "bv*[height<=420]+ba[ext=m4a]/b[height<=420]" \
  -o "$CHANNEL_DIR/%(title)s.%(ext)s"

  echo " Finished $NAME"
  echo
done