#!/bin/sh

# The $NAME variable is passed from sketchy_topbar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/sketchy_topbar/config/events#events-and-scripting
#

if [ -z "$NAME" ]; then
  echo "Error: NAME variable is not set."
  exit 1
fi

DATE_LABEL=$(date '+%a %b %d')
sketchy_topbar --set "$NAME" "label=$DATE_LABEL"
