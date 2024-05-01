export ZSH="$HOME/.oh-my-zsh"

if [[ ":$PATH:" != *":/usr/local/opt/openjdk/bin:"* ]]; then
    export PATH="/usr/local/opt/openjdk/bin:$PATH"
fi

export CPPFLAGS="-I/usr/local/opt/openjdk/include"

if [[ ":$PATH:" != *":/usr/local/opt/ruby@3.1/bin:"* ]]; then
    export PATH="/usr/local/opt/ruby@3.1/bin:$PATH"
fi

export LDFLAGS="-L/usr/local/opt/ruby@3.1/lib"
export CPPFLAGS="-I/usr/local/opt/ruby@3.1/include"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

export PKG_CONFIG_PATH="/usr/local/opt/xcb-util-image/lib/pkgconfig:$PKG_CONFIG_PATH"

if [[ ":$PATH:" != *":/usr/local/sbin:"* ]]; then
    export PATH="/usr/local/sbin:$PATH"
fi

if [[ ":$PATH:" != *":/Applications/iTerm.app/Contents/Resources:"* ]]; then
    export PATH="/Applications/iTerm.app/Contents/Resources:${PATH}"
fi

# export TERM=xterm-256color

export EDITOR=lvim

if [[ ":$PATH:" != *":/Users/crazycatzhang/.local/bin:"* ]]; then
    export PATH="/Users/crazycatzhang/.local/bin:$PATH"
fi

if [[ ":$PATH:" != *":/Users/crazycatzhang/.cargo/bin:"* ]]; then
    export PATH="$PATH:/Users/crazycatzhang/.cargo/bin"
fi

if [[ ":$PATH:" != *":~/.console-ninja/.bin:"* ]]; then
    export PATH="~/.console-ninja/.bin:$PATH"
fi

if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  if [[ -n "$PATH" ]]; then
    export PATH="$PATH:/usr/local/opt/fzf/bin"
  else
    export PATH="/usr/local/opt/fzf/bin"
  fi
fi

export PATH="$PATH:$(gem environment gemdir)/bin"

export PATH="/usr/local/Cellar/perl/5.38.2_1/bin:$PATH"

export PATH=$PATH:$(go env GOPATH)/bin

export PATH="$PATH:/Users/crazycatzhang/Library/Application Support/Coursier/bin"

export PATH=$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!seen[$0]++' | sed 's/:$//')

