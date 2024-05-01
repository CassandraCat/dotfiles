#!/bin/sh

status() {
	if osascript -e 'tell application "Spotify"
    set playerState to player state as string
end tell
playerState
' | grep -q 'playing'; then
		echo "playing"
	else
		echo "paused"
	fi
}

if [ $(status) = "playing" ]; then
	sketchy_topbar --set pause icon=''
else
	sketchy_topbar --set pause icon=''
fi
