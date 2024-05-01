#!/bin/sh

source "$HOME/.config/colors.sh"
source "$HOME/.config/icons.sh"
source "$HOME/.config/sketchy_topbar/icons.sh"
source "$HOME/.config/sketchy_topbar/colors.sh"

IP_ADDRESS=$(networksetup -getairportnetwork en0 | awk -F': ' '{print $2}')
IS_VPN=$(scutil --nwi | grep -m1 'utun' | awk '{ print $1 }')

if [[ $IS_VPN != "" ]]; then
  COLOR=$COLOR_SEVEN
  ICON=$ICON_VPN
  LABEL="VPN"
elif [[ $IP_ADDRESS != "" ]]; then
  COLOR=$COLOR_SEVEN
  ICON=$ICON_WIFI
  LABEL=$IP_ADDRESS
else
  COLOR=$COLOR_FIVE
  ICON=$ICON_WIFI_OFF
  LABEL="Not Connected"
fi

sketchy_topbar --set $NAME background.color=$COLOR \
  icon=$ICON \
  label="$LABEL"
