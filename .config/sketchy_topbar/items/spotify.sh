#!/bin/sh

BACK_SCRIPT="cd ~/.config/sketchy_topbar/spotify && ./back.sh"
PAUSE_PLAY_SCRIPT="cd ~/.config/sketchy_topbar/spotify/ && ./playpause.sh && source '$PLUGIN_DIR/spotify.sh'"
FORWARD_SCRIPT="cd ~/.config/sketchy_topbar/spotify && ./forward.sh"

sketchy_topbar --add item back left \
    --set back icon="" \
    icon.font="Material Icons:Regular:20.0" \
    icon.color=0xffbfc945 \
    icon.padding_left=15 \
    icon.padding_right=15 \
    background.drawing=on \
    background.height=30 \
    background.corner_radius=20 \
    blur_radius=22 \
    padding_left=2 \
    background.border_width=0 \
    click_script="$BACK_SCRIPT" \
    --subscribe back mouse.clicked

sketchy_topbar --add item pause left \
    --set pause icon="" \
    icon.font="Material Icons:Regular:18.0" \
    icon.color=0xffE68610 \
    icon.padding_right=15 \
    icon.padding_left=15 \
    background.padding_left=5 \
    background.drawing=on \
    background.border_width=0 \
    background.height=30 \
    padding_left=-2 \
    background.corner_radius=10 \
    click_script="$PAUSE_PLAY_SCRIPT" \
    script="$PLUGIN_DIR/spotify.sh" \
    update_freq=2 \
    --subscribe pause mouse.clicked

sketchy_topbar --add item forward left \
    --set forward icon="" \
    icon.font="Material Icons:Regular:20.0" \
    icon.color=0xffbfc945 \
    icon.padding_left=15 \
    icon.padding_right=15 \
    background.padding_left=5 \
    padding_left=-2 \
    background.border_width=0 \
    background.drawing=on \
    background.height=30 \
    background.corner_radius=20 \
    click_script="$FORWARD_SCRIPT" \
    --subscribe forward mouse.clicked

. "$PLUGIN_DIR/spotify.sh"
