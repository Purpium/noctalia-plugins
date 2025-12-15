#!/bin/bash

# Source and destination paths
SRC="$HOME/Projects/noctalia-plugins/better-system-monitor"
DEST="$HOME/dotfiles/.config/noctalia/plugins"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST"

# Copy the folder (with contents) to the destination
cp -r "$SRC" "$DEST"

# Optional: print success message
echo "Copied '$SRC' to '$DEST'"

