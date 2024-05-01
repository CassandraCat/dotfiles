#!/bin/sh

sketchy_topbar --add item line left \
  --set line icon="" \
  icon.color=0xff9fd06a \
  icon.font="MonaspiceRn Nerd Font Propo:Regular:14.8" \
  \
  --add item playing left \
  --set playing update_freq=5 \
  label.font="MonaspiceRn Nerd Font Propo:Bold Italic:12.0" \
  label.padding_left=-15 \
  label.color=$COLOR_TWO \
  script="$PLUGIN_DIR/playing.sh" \
  label.y_offset=-1 \
  background.padding_left=3 \
  \
  --add item music left \
  --set music icon="󰎇" \
  icon.color=0xff9fd06a \
  icon.y_offset=-1 \
  icon.font="MonaspiceRn Nerd Font Propo:Regular:14.8"

