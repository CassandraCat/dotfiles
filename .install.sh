#!/bin/zsh

# Install Xcode cli tools
echo "Installing commandline tools..."
xcode-select --install

# Homebrew
## Install
echo "Installing Brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

## Taps
echo "Tapping Brew..."
brew tap buo/cask-upgrade
brew tap felixkratz/formulae
brew tap hashicorp/tap
brew tap homebrew/cask-fonts
brew tap homebrew/services
brew tap jesseduffield/lazygit
brew tap jstkdng/programs
brew tap koekeishiya/formulae
brew tap lencx/chatgpt
brew tap wez/wezterm
brew tap mongodb/brew

## Formulae
echo "Installing Brew Formulae..."
## Development
brew install cmake
brew install coursier
brew install ctags
brew install gopls
brew install julia
brew install luarocks
brew install neovim
brew install opencv
brew install php
brew install pyinstaller
brew install rust
brew install typescript
brew install vim
brew install yarn
brew install mongodb/brew/mongodb-community@6.0
brew install mongosh
brew install mysql
brew install redis

## Code Analysis
brew install hadolint
brew install luacheck
brew install markdownlint-cli
brew install semgrep
brew install shellcheck

## Dependency Management
brew install composer
brew install mas
brew install nvm
brew install pipx

## File Tools
brew install fd
brew install fzf
brew install ripgrep
brew install the_silver_searcher
brew install unar
brew install wget
brew install xcb-util-image
brew install xclip

## System Management
brew install autojump
brew install neofetch
brew install raitnbarf
brew install skhd
brew install starship
brew install stow
brew install switchaudio-osx
brew install task
brew install timewarrior
brew install tmux
brew install tmuxinator
brew install yabai
brew install zoxide
brew install nowplaying-cli

## Text Processing
brew install bat
brew install figlet
brew install stylua
brew install vale

## Image Tools
brew install ffmpegthumbnailer
brew install viu

## Language Runtimes
brew install go
brew install lua
brew install node
brew install ruby

## Utilities
brew install cask
brew install joshuto
brew install lazygit
brew install llvm
brew install sketchybar
brew install yazi
brew install zig

## Essentials
brew install gsl
brew install boost
brew install libomp
brew install armadillo
brew install borders

## Science
brew install mactex
brew install hdf5
brew install gnuplot
brew install texlab

## Terminal Enhancements
brew install helix
brew install zsh-autosuggestions
brew install zsh-fast-syntax-highlighting

## Nice-to-Have
brew install lulu
brew install btop
brew install svim
brew install dooit

## Casks
echo "Installing Brew Casks..."
## Web
brew install --cask arc
brew install --cask firefox
brew install --cask google-chrome

## Dev
brew install --cask codekit
brew install --cask docker
brew install --cask iterm2
brew install --cask jetbrains-toolbox
brew install --cask kaleidoscope
brew install --cask navicat-premium
brew install --cask postman
brew install --cask sublime-text
brew install --cask visual-studio-code
brew install --cask tower
brew install --cask wezterm
brew install --cask kitty
brew install --cask warp
brew install --cask termius
brew install --cask charles
brew install --cask squirrel

## Notes
brew install --cask notion
brew install --cask obsidian
brew install --cask typora
brew install --cask xmind
brew install --cask skim

## System
brew install --cask alfred
brew install --cask bettertouchtool
brew install --cask caffeine
brew install --cask cleanmymac
brew install --cask karabiner-elements
brew install --cask keka
brew install --cask rectangle
brew install --cask surge
brew install --cask popclip
brew install --cask paragon-ntfs

## Productivity
brew install --cask 1password
brew install --cask cheatsheet
brew install --cask raycast
brew install --cask setapp
brew install --cask snipaste
brew install --cask thor
brew install --cask tickeys

## Communication
brew install --cask discord
brew install --cask slack
brew install --cask telegram
brew install --cask wechat
brew install --cask qq

# Media
brew install --cask iina
brew install --cask neteasemusic
brew install --cask qqmusic
brew install --cask spotify
brew install --cask bilibili
brew install --cask qqlive
brew install --cask loopback
brew install --cask obs
brew install --cask yesplaymusic

## Cloud
brew install --cask adrive
brew install --cask dropbox
brew install -- cask syncthing

## Fonts
brew install --cask font-cascadia-code
brew install --cask font-sf-mono
brew install --cask font-sf-pro
brew install --cask sf-symbols
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono
brew install --cask font-fira-code

## Entertainment
brew install --cask steam

# Mac App Store Apps
echo "Installing Mac App Store Apps..."
mas install 1101244278  ## iPic
mas install 497799835   ## Xcode
mas install 461788075   ## Movist
mas install 1482454543  ## Twitter
mas install 408981434   ## iMovie
mas install 409183694   ## Keynote
mas install 1443988620  ## Quantumult X
mas install 1355679052  ## Dropover
mas install 1630034110  ## Bob
mas install 409201541   ## Pages
mas installl 682658836  ## GarageBand
mas install 937984704   ## Amphetamine
mas install 409203825   ## Numbers
mas install 789066512   ## Maipo

# macOS Settings
echo "Changing macOS defaults..."
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

# Copying and checking out configuration files
echo "Planting Configuration Files..."
[ ! -d "$HOME/dotfiles" ] && git clone --bare git@github.com:CrazyCatZhang/dotfiles.git $HOME/dotfiles
git --git-dir=$HOME/dotfiles/ --work-tree=$HOME checkout main

# Installing Fonts
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf
git clone git@github.com:shaunsingh/SFMono-Nerd-Font-Ligaturized.git /tmp/SFMono_Nerd_Font
mv /tmp/SFMono_Nerd_Font/* $HOME/Library/Fonts
rm -rf /tmp/SFMono_Nerd_Font/

# SbarLua
(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)

# zsh config
source $HOME/.zshrc

# Hidden Untracked Files
git config --local status.showUntrackedFiles no

# Installing helix language server
git clone https://github.com/estin/simple-completion-language-server.git /tmp/simple-completion-language-server
(cd /tmp/simple-completion-language-server && cargo install --path .)
rm -rf /tmp/simple-completion-language-server

# Python Packages (mainly for data science)
echo "Installing Python Packages..."
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

# Rust Packages
echo "Installing Rust Packages..."
cargo install fd-find
cargo install ripgrep
cargo install rust-analyzer
cargo install selene

# Lunarvim Config
echo "Installing Lunarvim..."
bash <(curl -s "https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh")

# Lunarvim Java Support
echo "Initializing Java Support..."
mkdir -p ~/workspace
git clone git@github.com:microsoft/java-debug.git ~/.config/lvim/.java-debug
cd ~/.config/lvim/.java-debug/
./mvnw clean install
git clone git@github.com:microsoft/vscode-java-test.git ~/.config/lvim/.vscode-java-test
cd ~/.config/lvim/.vscode-java-test
npm install
npm run build-plugin

# Start Services
echo "Starting Services (grant permissions)..."
brew services start skhd
brew services start yabai
brew services start sketchybar
brew services start borders
brew services start svim

csrutil status
echo "(optional) Disable SIP for advanced yabai features."
echo "(optional) Add sudoer manually:\n '$(whoami) ALL = (root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | awk "{print \$1;}") $(which yabai) --load-sa' to '/private/etc/sudoers.d/yabai'"
echo "Installation complete...\n"
