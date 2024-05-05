#!/bin/bash

LOG_FILE="$HOME/install.log"

log_message() {
  local message="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
  echo $message | tee -a $LOG_FILE
}

check_dependency() {
  local dependency=$1
  if ! command -v $dependency &> /dev/null; then
    log_message "Error: $dependency is not installed."
    exit 1
  fi
}

install_xcode_cli_tools() {
  check_dependency "xcode-select"
  if ! xcode-select -p &> /dev/null;
    log_message "Installing commandline tools..."
    xcode-select --install
  else
    log_message "Xcode Command Line Tools already installed. Skipping..."
  fi
}

install_homebrew() {
  if ! command -v brew &> /dev/null; then
    log_message "Installing Brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew analytics off
  else
    log_message "Homebrew already installed. Skipping..."
  fi
}

tap_brew() {
  local -a taps=(
    buo/cask-upgrade
    felixkratz/formulae
    hashicorp/tap
    homebrew/cask-fonts
    homebrew/services
    jesseduffield/lazygit
    jstkdng/programs
    koekeishiya/formulae
    lencx/chatgpt
    wez/wezterm
    mongodb/brew
  )

  local current_taps=$(brew tap)

  for tap in "${taps[@]}"; do
    if echo "$current_taps" | grep -q "^$tap\$"; then  # Check if tap is already tapped
      log_message "Brew tap $tap already exists. Skipping..."
    else
      log_message "Tapping Brew tap: $tap"
      if ! brew tap "$tap"; then
        log_message "Failed to tap $tap. Continuing with next tap."
      fi
    fi
  done
}

install_brew_formulae() {
  local -a formulae=(
    cmake
    coursier
    ctags
    gopls
    julia
    luarocks
    neovim
    opencv
    php
    pyinstaller
    rust
    typescript
    vim
    yarn
    mongodb/brew/mongodb-community@6.0
    mongosh
    mysql
    redis
    hadolint
    luacheck
    markdownlint-cli
    semgrep
    shellcheck
    composer
    mas
    nvm
    pipx
    fd
    fzf
    ripgrep
    the_silver_searcher
    unar
    wget
    xcb-util-image
    xclip
    autojump
    neofetch
    raitnbarf
    skhd
    starship
    stow
    switchaudio-osx
    task
    timewarrior
    tmux
    tmuxinator
    yabai
    zoxide
    nowplaying-cli
    bat
    figlet
    stylua
    vale
    ffmpegthumbnailer
    viu
    go
    lua
    node
    ruby
    cask
    joshuto
    lazygit
    llvm
    sketchybar
    yazi
    zig
    gsl
    boost
    libomp
    armadillo
    borders
    mactex
    hdf5
    gnuplot
    texlab
    helix
    zsh-autosuggestions
    zsh-fast-syntax-highlighting
    lulu
    btop
    svim
    dooit
  )

  for formula in "${formulae[@]}"; do
    if brew list --formula | grep -q "^$formula\$"; then  # Check if formula is already installed
      log_message "Brew formula $formula already installed. Skipping..."
    else
      log_message "Installing Brew formula: $formula"
      if ! brew install "$formula"; then
        log_message "Failed to install $formula. Continuing with next formula."
      fi
    fi
  done
}

install_brew_casks() {
  local -a casks=(
    arc
    firefox
    google-chrome
    codekit
    docker
    iterm2
    jetbrains-toolbox
    kaleidoscope
    navicat-premium
    postman
    sublime-text
    visual-studio-code
    tower
    wezterm
    kitty
    warp
    termius
    charles
    squirrel
    notion
    obsidian
    typora
    xmind
    skim
    alfred
    bettertouchtool
    caffeine
    cleanmymac
    karabiner-elements
    keka
    rectangle
    surge
    popclip
    paragon-ntfs
    1password
    cheatsheet
    raycast
    setapp
    snipaste
    thor
    tickeys
    discord
    slack
    telegram
    wechat
    qq
    iina
    neteasemusic
    qqmusic
    spotify
    bilibili
    qqlive
    loopback
    obs
    yesplaymusic
    adrive
    dropbox
    syncthing
    font-cascadia-code
    font-sf-mono
    font-sf-pro
    sf-symbols
    font-hack-nerd-font
    font-jetbrains-mono
    font-fira-code
    steam
  )

  for cask in "${casks[@]}"; do
    if brew list --cask | grep -q "^$cask\$"; then  # Check if cask is already installed
      log_message "Brew cask $cask already installed. Skipping..."
    else
      log_message "Installing Brew cask: $cask"
      if ! brew install --cask "$cask"; then
        log_message "Failed to install $cask. Continuing with next cask."
      fi
    fi
  done
}

install_mac_app_store_apps() {
  local -a app_ids=(
    1101244278 # iPic
    497799835  # Xcode
    461788075  # Movist
    1482454543 # Twitter
    408981434  # iMovie
    409183694  # Keynote
    1443988620 # Quantumult X
    1355679052 # Dropover
    1630034110 # Bob
    409201541  # Pages
    682658836  # GarageBand
    937984704  # Amphetamine
    409203825  # Numbers
    789066512  # Maipo
  )

  log_message "Installing Mac App Store Apps..."

  for app_id in "${app_ids[@]}"; do
    log_message "Installing app ID $app_id..."
    mas install $app_id
  done
}

change_macos_defaults() {
  log_message "Changing macOS defaults..."
  defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.spaces spans-displays -bool false
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock "mru-spaces" -bool "false"
  defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
  defaults write com.apple.LaunchServices LSQuarantine -bool false
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
  defaults write NSGlobalDomain KeyRepeat -int 1
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  defaults write NSGlobalDomain _HIHideMenuBar -bool true
  defaults write NSGlobalDomain AppleHighlightColor -string "0.65098 0.85490 0.58431"
  defaults write NSGlobalDomain AppleAccentColor -int 1
  defaults write com.apple.screencapture location -string "$HOME/Desktop"
  defaults write com.apple.screencapture disable-shadow -bool true
  defaults write com.apple.screencapture type -string "png"
  defaults write com.apple.finder DisableAllAnimations -bool true
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
  defaults write com.apple.Finder AppleShowAllFiles -bool true
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
  defaults write com.apple.finder ShowStatusBar -bool false
  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool YES
  defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
  defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
  defaults write -g NSWindowShouldDragOnGesture YES
}

clone_dotfiles() {
  log_message "Cloning dotfiles..."
  [ ! -d "$HOME/dotfiles" ] && git clone --bare git@github.com:CrazyCatZhang/dotfiles.git $HOME/dotfiles
  git --git-dir=$HOME/dotfiles/ --work-tree=$HOME checkout main
}

install_fonts() {
  log_message "Installing Fonts..."
  curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf
  git clone git@github.com:shaunsingh/SFMono-Nerd-Font-Ligaturized.git /tmp/SFMono_Nerd_Font
  mv /tmp/SFMono_Nerd_Font/* $HOME/Library/Fonts
  rm -rf /tmp/SFMono_Nerd_Font/
}

install_sbarlua() {
  log_message "Installing SbarLua..."
  (git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)
}

refresh_zsh_config() {
  log_message "Refreshing .zshrc..."
  source $HOME/.zshrc
}

set_git_untracked_files() {
  log_message "Setting git to hide untracked files..."
  git config --local status.showUntrackedFiles no
}

install_helix_language_servers() {
  log_message "Installing language server..."
  git clone https://github.com/estin/simple-completion-language-server.git /tmp/simple-completion-language-server
  (cd /tmp/simple-completion-language-server && cargo install --path .)
  rm -rf /tmp/simple-completion-language-server
}

install_python_packages() {
  log_message "Installing Python Packages..."
  curl https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-x86_64.sh | sh
  source $HOME/.zshrc
  conda install -c apple tensorflow-deps
  conda install -c conda-forge pybind11
  conda install matplotlib
  conda install jupyterlab
  conda install seaborn
  conda install opencv
  conda install joblib
  conda inlstall pytables
  pip install tensorflow-macos
  pip install tensorflow-metal
  pip install debugpy
  pip install sklearn
  pip install vim-vint
  pip install yapf flake8 black
}

install_rust_packages() {
  log_message "Installing Rust Packages..."
  cargo install fd-find
  cargo install ripgrep
  cargo install rust-analyzer
  cargo install selene
}

install_lunarvim() {
  log_message "Installing Lunarvim..."
  bash <(curl -s "https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh")
}

setup_java_support_for_lunarvim() {
  log_message "Initializing Java Support..."
  mkdir -p ~/workspace
  git clone git@github.com:microsoft/java-debug.git ~/.config/lvim/.java-debug
  cd ~/.config/lvim/.java-debug/
  ./mvnw clean install
  git clone git@github.com:microsoft/vscode-java-test.git ~/.config/lvim/.vscode-java-test
  cd ~/.config/lvim/.vscode-java-test
  npm install
  npm run build-plugin
}

start_services() {
  log_message "Starting Services (grant permissions)..."
  brew services start skhd
  brew services start yabai
  brew services start sketchybar
  brew services start borders
  brew services start svim
}

main() {
  touch $LOG_FILE
  set -e
  set -o pipefail

  log_message "Starting installation..."

  read -p "This script will install several applications and tools, and change some system settings. Are you sure you want to continue? (y/N) " -n 1 -r
  echo # move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_xcode_cli_tools
    install_homebrew
    tap_brew
    install_brew_formulae
    install_brew_casks
    install_mac_app_store_apps
    change_macos_defaults
    clone_dotfiles
    install_fonts
    install_sbarlua
    refresh_zsh_config
    set_git_untracked_files
    install_helix_language_servers
    install_python_packages
    install_rust_packages
    install_lunarvim
    setup_java_support_for_lunarvim
    start_services
    log_message "Installation complete."
  else
    log_message "Installation aborted by user."
    exit 1
  fi
}

main "$@"
