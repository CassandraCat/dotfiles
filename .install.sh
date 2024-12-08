#!/bin/bash

# ====================
# 配置
# ====================
readonly LOG_FILE="$HOME/install.log"
readonly GITHUB_DOTFILES="git@github.com:CrazyCatZhang/dotfiles.git"
readonly FONTS_DIR="$HOME/Library/Fonts"
readonly CONFIG_DIR="$HOME/.config"
readonly WORKSPACE_DIR="$HOME/workspace"

# Homebrew taps
readonly TAPS=(
    "blacktop/tap"
    "buo/cask-upgrade"
    "felixkratz/formulae"
    "hashicorp/tap"
    "homebrew/services"
    "jesseduffield/lazygit"
    "jstkdng/programs"
    "koekeishiya/formulae"
    "lencx/chatgpt"
    "mongodb/brew"
    "pkgxdev/made"
    "wez/wezterm"
)

# Homebrew formulae
readonly FORMULAE=(
    "autojump"
    "bat"
    "cask"
    "ccat"
    "cmake"
    "cmake-docs"
    "composer"
    "coursier"
    "ctags"
    "exiftool"
    "fastfetch"
    "fd"
    "ffmpegthumbnailer"
    "figlet"
    "fzf"
    "gh"
    "git"
    "git-lfs"
    "gitmoji"
    "gnu-sed"
    "go"
    "gopls"
    "hadolint"
    "joshuto"
    "jq"
    "julia"
    "skhd"
    "yabai"
    "lerna"
    "lporg"
    "lsd"
    "lazygit"
    "lua-language-server"
    "luacheck"
    "luarocks"
    "markdownlint-cli"
    "mas"
    "maven"
    "macchina"
    "neovim"
    "nvm"
    "opencv"
    "pillow"
    "pipx"
    "pkgx"
    "poppler"
    "portablegl"
    "powerlevel10k"
    "pyinstaller"
    "rainbarf"
    "ripgrep"
    "ruby@3.1"
    "rust"
    "semgrep"
    "shellcheck"
    "shfmt"
    "starship"
    "stow"
    "stylua"
    "superfile"
    "switchaudio-osx"
    "silicon"
    "sketchybar"
    "svim"
    "spicetify-cli"
    "terraform"
    "task"
    "the_silver_searcher"
    "timewarrior"
    "tmuxinator"
    "typescript"
    "unar"
    "vale"
    "vim"
    "viu"
    "wget"
    "xcb-util-image"
    "xclip"
    "yarn"
    "yazi"
    "zig"
    "zoxide"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
)

# Homebrew casks
readonly CASKS=(
    "1password"
    "activedock"
    "adobe-creative-cloud"
    "adrive"
    "alfred"
    "apifox"
    "appcleaner"
    "arc"
    "background-music"
    "battery-buddy"
    "bettertouchtool"
    "bilibili"
    "claude"
    "caffeine"
    "charles"
    "cheatsheet"
    "codekit"
    "dingtalk"
    "discord"
    "docker"
    "dockx"
    "firefox"
    "flux"
    "font-cascadia-code"
    "font-material-design-icons-webfont"
    "font-sf-mono"
    "font-sf-pro"
    "fork"
    "feishu"
    "google-chrome"
    "hammerspoon"
    "hbuilderx"
    "iina"
    "iterm2"
    "jetbrains-toolbox"
    "kaleidoscope"
    "karabiner-elements"
    "keka"
    "kitty"
    "landrop"
    "loopback"
    "metasploit"
    "mos"
    "navicat-premium"
    "neteasemusic"
    "netnewswire"
    "notion"
    "obs"
    "paragon-ntfs"
    "popclip"
    "postico"
    "postman"
    "proton-mail"
    "qq"
    "qqmusic"
    "raycast"
    "rectangle"
    "scrivener"
    "sequel-ace"
    "setapp"
    "sf-symbols"
    "skim"
    "slack"
    "snipaste"
    "sourcetree"
    "spotify"
    "squirrel"
    "steam"
    "sublime-text"
    "surge"
    "syncthing"
    "tableplus"
    "telegram"
    "termius"
    "thor"
    "thunderbird"
    "tickeys"
    "todesk"
    "tower"
    "typora"
    "visual-studio-code"
    "warp"
    "wechat"
    "wezterm"
    "wireshark-chmodbpf"
    "wpsoffice"
    "xmind"
    "yesplaymusic"
    "youku"
    "zed"
)

# Mac App Store apps
readonly MAS_APPS=(
    "1101244278" # iPic
    "497799835"  # Xcode
    "461788075"  # Movist
    "1482454543" # Twitter
    "408981434"  # iMovie
    "409183694"  # Keynote
    "1443988620" # Quantumult X
    "1355679052" # Dropover
    "1630034110" # Bob
    "409201541"  # Pages
    "682658836"  # GarageBand
    "937984704"  # Amphetamine
    "409203825"  # Numbers
    "789066512"  # Maipo
)

# ====================
# 错误处理
# ====================
set -euo pipefail
trap 'echo "错误发生在第 $LINENO 行: $BASH_COMMAND"' ERR

# ====================
# 工具函数
# ====================
log_message() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

log_info() { log_message "INFO" "$1"; }
log_error() { log_message "ERROR" "$1"; }
log_success() { log_message "SUCCESS" "$1"; }

check_system() {
    if [[ "$(uname)" != "Darwin" ]]; then
        log_error "此脚本仅支持 macOS"
        exit 1
    }

    if ! sw_vers -productVersion | grep -E "^(11|12|13|14)" > /dev/null; then
        log_error "需要 macOS Big Sur (11.0) 或更高版本"
        exit 1
    }
}

check_dependency() {
    local cmd=$1
    if ! command -v "$cmd" &> /dev/null; then
        log_error "未找到必需的依赖: $cmd"
        return 1
    fi
    return 0
}

# ====================
# 安装函数
# ====================
install_xcode_cli_tools() {
    log_info "检查 Xcode Command Line Tools..."
    if ! xcode-select -p &> /dev/null; then
        log_info "安装 Xcode Command Line Tools..."
        xcode-select --install
        log_success "Xcode Command Line Tools 安装完成"
    else
        log_info "Xcode Command Line Tools 已安装"
    fi
}

setup_homebrew() {
    if ! command -v brew &> /dev/null; then
        log_info "安装 Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
            log_error "Homebrew 安装失败"
            return 1
        }
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        log_info "更新 Homebrew..."
        brew update || log_error "Homebrew 更新失败"
    fi
    brew analytics off
    log_success "Homebrew 设置完成"
}

install_brew_taps() {
    log_info "安装 Homebrew taps..."
    local failed_taps=()

    for tap in "${TAPS[@]}"; do
        if ! brew tap | grep -q "^$tap\$"; then
            if ! brew tap "$tap"; then
                failed_taps+=("$tap")
                log_error "无法安装 tap: $tap"
            fi
        fi
    done

    if [ ${#failed_taps[@]} -eq 0 ]; then
        log_success "所有 taps 安装成功"
    else
        log_error "以下 taps 安装失败: ${failed_taps[*]}"
    fi
}

install_brew_packages() {
    local type=$1
    shift
    local packages=("$@")
    local failed_packages=()

    log_info "安装 Homebrew $type..."

    for package in "${packages[@]}"; do
        if ! brew list --$type | grep -q "^$package\$"; then
            if ! brew install $([ "$type" = "cask" ] && echo "--$type") "$package"; then
                failed_packages+=("$package")
                log_error "安装失败: $package"
                continue
            fi
        else
            log_info "已安装: $package"
        fi
    done

    if [ ${#failed_packages[@]} -eq 0 ]; then
        log_success "所有 $type 安装成功"
    else
        log_error "以下包安装失败: ${failed_packages[*]}"
    fi
}

install_mas_apps() {
    log_info "安装 Mac App Store 应用..."
    local failed_apps=()

    for app_id in "${MAS_APPS[@]}"; do
        if ! mas install "$app_id"; then
            failed_apps+=("$app_id")
            log_error "无法安装应用 ID: $app_id"
        fi
    done

    if [ ${#failed_apps[@]} -eq 0 ]; then
        log_success "所有 Mac App Store 应用安装成功"
    else
        log_error "以下应用安装失败: ${failed_apps[*]}"
    fi
}

setup_macos_defaults() {
    log_info "配置 macOS 系统设置..."

    # 网络
    defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

    # Dock
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock "mru-spaces" -bool false
    defaults write com.apple.dock springboard-rows -int 6
    defaults write com.apple.dock springboard-columns -int 8
    defaults write com.apple.dock mineffect -string genie

    # 系统
    defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
    defaults write com.apple.LaunchServices LSQuarantine -bool false
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
    defaults write NSGlobalDomain KeyRepeat -int 1
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    defaults write NSGlobalDomain _HIHideMenuBar -bool true

    # Finder
    defaults write com.apple.finder DisableAllAnimations -bool true
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
    defaults write com.apple.Finder AppleShowAllFiles -bool true

    # Safari
    defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
    defaults write com.apple.Safari IncludeDevelopMenu -bool true

    log_success "macOS 配置完成"
}

setup_dotfiles() {
    log_info "配置 dotfiles..."

    if [ ! -d "$HOME/dotfiles" ]; then
        git clone --bare "$GITHUB_DOTFILES" "$HOME/dotfiles" || {
            log_error "dotfiles 克隆失败"
            return 1
        }
    fi

    git --git-dir="$HOME/dotfiles/" --work-tree="$HOME" checkout main || {
        log_error "dotfiles checkout 失败"
        return 1
    }

    # 同步配置
    rm -rf "$HOME/.hammerspoon" "$HOME/.tmux.conf" "$HOME/.zshrc" "$HOME/.gitconfig" \
           "$HOME/.gitignore_global" "$HOME/.config/"*

    cd "$HOME/dotfiles" && stow . || {
        log_error "dotfiles stow 失败"
        return 1
    }

    git config --local status.showUntrackedFiles no

    log_success "dotfiles 配置完成"
}

install_fonts() {
    log_info "安装字体..."

    # 创建字体目录
    mkdir -p "$FONTS_DIR"

    # 下载并安装 sketchybar 字体
    curl -L "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf" \
         -o "$FONTS_DIR/sketchybar-app-font.ttf" || log_error "sketchybar 字体下载失败"

    # 克隆并安装 SF Mono Nerd Font
    git clone "git@github.com:shaunsingh/SFMono-Nerd-Font-Ligaturized.git" "/tmp/SFMono_Nerd_Font" || {
        log_error "SF Mono 字体克隆失败"
        return 1
    }

    mv /tmp/SFMono_Nerd_Font/* "$FONTS_DIR/"
    rm -rf /tmp/SFMono_Nerd_Font/

    log_success "字体安装完成"
}

install_development_tools() {
    log_info "安装开发工具..."
    # SbarLua
    install_sbarlua() {
        log_info "安装 SbarLua..."
        (git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && 
         cd /tmp/SbarLua/ && 
         make install && 
         rm -rf /tmp/SbarLua/) || log_error "SbarLua 安装失败"
    }

    # Helix Language Servers
    install_helix_language_servers() {
        log_info "安装 language server..."
        git clone https://github.com/estin/simple-completion-language-server.git /tmp/simple-completion-language-server || {
            log_error "Language server 克隆失败"
            return 1
        }
        (cd /tmp/simple-completion-language-server && cargo install --path .) || log_error "Language server 安装失败"
        rm -rf /tmp/simple-completion-language-server
    }

    # Python 环境
    setup_python_environment() {
        log_info "配置 Python 环境..."

        # 安装 Miniforge
        curl -L https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh -o /tmp/miniforge.sh || {
            log_error "Miniforge 下载失败"
            return 1
        }
        bash /tmp/miniforge.sh -b || log_error "Miniforge 安装失败"
        rm /tmp/miniforge.sh

        # 初始化环境
        source "$HOME/.zshrc"

        # 安装 conda 包
        local conda_packages=(
            "tensorflow-deps"
            "pybind11"
            "matplotlib"
            "jupyterlab"
            "seaborn"
            "opencv"
            "joblib"
            "pytables"
        )

        for package in "${conda_packages[@]}"; do
            conda install -y "$package" || log_error "Conda 包安装失败: $package"
        done

        # 安装 pip 包
        local pip_packages=(
            "tensorflow-macos"
            "tensorflow-metal"
            "debugpy"
            "sklearn"
            "vim-vint"
            "yapf"
            "flake8"
            "black"
        )

        for package in "${pip_packages[@]}"; do
            pip install "$package" || log_error "Pip 包安装失败: $package"
        done
    }

    # Rust 环境
    setup_rust_environment() {
        log_info "配置 Rust 环境..."

        local cargo_packages=(
            "fd-find"
            "ripgrep"
            "rust-analyzer"
            "selene"
        )

        for package in "${cargo_packages[@]}"; do
            cargo install "$package" || log_error "Cargo 包安装失败: $package"
        done
    }

    # LunarVim
    setup_lunarvim() {
        log_info "安装 LunarVim..."

        bash <(curl -s "https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh") || {
            log_error "LunarVim 安装失败"
            return 1
        }

        # Java 支持
        setup_java_support
    }

    setup_java_support() {
        log_info "配置 Java 支持..."

        mkdir -p "$WORKSPACE_DIR"

        # Java Debug
        git clone git@github.com:microsoft/java-debug.git "$CONFIG_DIR/lvim/.java-debug" || log_error "java-debug 克隆失败"
        (cd "$CONFIG_DIR/lvim/.java-debug/" && ./mvnw clean install) || log_error "java-debug 构建失败"

        # Java Test
        git clone git@github.com:microsoft/vscode-java-test.git "$CONFIG_DIR/lvim/.vscode-java-test" || log_error "vscode-java-test 克隆失败"
        (cd "$CONFIG_DIR/lvim/.vscode-java-test" && npm install && npm run build-plugin) || log_error "vscode-java-test 构建失败"
    }

    start_system_services() {
        log_info "启动系统服务..."

        local services=(
            "skhd"
            "yabai"
            "sketchybar"
            "borders"
            "svim"
        )

        for service in "${services[@]}"; do
            brew services start "$service" || log_error "服务启动失败: $service"
        done

        log_success "系统服务启动完成"
    }

    cleanup() {
        log_info "清理安装残留..."
        brew cleanup
        rm -rf /tmp/*
    }
}

# ====================
# 主函数
# ====================
main() {
    # 初始化日志
    touch "$LOG_FILE"
    log_info "开始系统配置..."

    # 确认安装
    read -p "此脚本将安装多个应用和工具，并修改系统设置。是否继续？(y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_error "用户取消安装"
        exit 1
    fi

    # 系统检查
    check_system

    # 执行安装步骤
    install_xcode_cli_tools
    setup_homebrew
    install_brew_taps
    install_brew_packages formula "${FORMULAE[@]}"
    install_brew_packages cask "${CASKS[@]}"
    install_mas_apps
    setup_macos_defaults
    setup_dotfiles
    install_fonts
    install_sbarlua
    install_helix_language_servers
    setup_python_environment
    setup_rust_environment
    setup_lunarvim
    start_system_services
    cleanup

    # 完成
    log_success "系统配置完成！请重启系统以应用所有更改。"
}

# 执行主函数
main "$@"    
