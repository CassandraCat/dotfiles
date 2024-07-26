#!/bin/bash

HASH_FILE="$HOME/.yabai_last_hash"
YABAI_PATH="$(which yabai)"

if [ ! -x "$YABAI_PATH" ]; then
  echo "yabai not found."
  exit 1
fi

CURRENT_HASH=$(shasum -a 256 "$YABAI_PATH" | awk '{print $1}')

if [ -f "$HASH_FILE" ]; then
  LAST_HASH=$(cat "$HASH_FILE")
else
  LAST_HASH=""
fi

if [ "$CURRENT_HASH" != "$LAST_HASH" ]; then
  echo "Updating yabai hash in sudoers.d..."
  
  echo "$(whoami) ALL=(root) NOPASSWD: sha256:$CURRENT_HASH $YABAI_PATH --load-sa" | sudo tee /private/etc/sudoers.d/yabai > /dev/null
  
  echo "$CURRENT_HASH" > "$HASH_FILE"
  
  echo "yabai hash updated."
else
  echo "yabai hash unchanged."
fi




