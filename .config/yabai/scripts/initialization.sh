#!/usr/bin/env bash

tempDir=/tmp/yabai-tiling-floating-toggle
[ -d $tempDir ] && rm -rf $tempDir
mkdir $tempDir

# JSON array
displays=$(yabai -m query --displays)

# How many displays I am using currently
cnt=$(echo $displays | jq '.|length')

# For each display
for ((i = 0; i < $cnt; i++)); do
	display=$(echo $displays | jq ".[$i]")
	index=$(echo $display | jq ".index") # display index

	# Get the coordinates of top left cornor, the width and the height of the display
	read -r x0 y0 w0 h0 <<<$(echo $(echo $display | jq ".frame" | jq ".x, .y, .w, .h"))

	# Calcuate the width and the height of the window
	if [ $h0 -gt $w0 ]; then
		w=$(echo "$w0 * 10 / 12" | bc)
		h=$(echo "$w * 2 / 3" | bc)
	else
		h=$(echo "$h0 * 10 / 12" | bc)
		w=$(echo "$h * 3 / 2" | bc)
	fi
	windowSize=($(yabai -m query --windows --window | jq '[.frame.w, .frame.h] | map(floor) | map(.+0) | join(",")'))
	IFS=',' read -r width height <<<"${windowSize[0]}"
	echo "Window size: width=$width, height=$height"

	# Calculate the coordinates of the top left corner of the window
	x=$(echo "$x0 + ($w0 - $w) / 2" | bc)
	y=$(echo "$y0 + ($h0 - $h) / 2" | bc)

	# Store these information in a temp file
	cat >/tmp/yabai-tiling-floating-toggle/display-$index <<EOF
  x=$x
  y=$y
  w=$w
  h=$h
EOF

done
