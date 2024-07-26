#!/bin/bash

currentsecs=$(date +%-H)
if [[ $currentsecs -lt 1 ]]; then
  sed -i '' 's/set -g status-bg .*/set -g status-bg "#1F1F28"/g' /Users/crazycatzhang/.tmux.conf
elif [[ $currentsecs -gt 0 && $currentsecs -lt 9 ]]; then
  sed -i '' 's/set -g status-bg .*/set -g status-bg "#191724"/g' /Users/crazycatzhang/.tmux.conf
elif [[ $currentsecs -gt 8 && $currentsecs -lt 17 ]]; then
  sed -i '' 's/set -g status-bg .*/set -g status-bg "#1A1B26"/g' /Users/crazycatzhang/.tmux.conf
elif [[ $currentsecs -gt 16 && $currentsecs -lt 21 ]]; then
  sed -i '' 's/set -g status-bg .*/set -g status-bg "#1E1E2E"/g' /Users/crazycatzhang/.tmux.conf
elif [[ $currentsecs -gt 20 ]]; then
  sed -i '' 's/set -g status-bg .*/set -g status-bg "#1F1F28"/g' /Users/crazycatzhang/.tmux.conf
fi
