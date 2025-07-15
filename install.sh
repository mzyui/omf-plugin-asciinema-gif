#!/bin/bash

FISH_FUNCTIONS_DIR="$HOME/.config/fish/functions"
SOURCE_FILE="functions/asciinema.fish"
DEST_FILE="$FISH_FUNCTIONS_DIR/asciinema.fish"

echo "Ensuring $FISH_FUNCTIONS_DIR exists..."
mkdir -p "$FISH_FUNCTIONS_DIR"

if [ -f "$DEST_FILE" ]; then
    echo "Existing asciinema.fish found in $FISH_FUNCTIONS_DIR. Overwriting..."
    rm "$DEST_FILE"
fi

echo "Moving $SOURCE_FILE to $DEST_FILE..."
mv "$SOURCE_FILE" "$DEST_FILE"

echo "Updating fish completions..."
fish -c "fish_update_completions"

echo "Installation complete. Please restart your fish shell or open a new terminal session."
