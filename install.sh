#!/bin/bash
set -e

echo "🚀 Setting up Neovim environment..."

# rootならsudo不要
if [ "$EUID" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

$SUDO apt-get update
$SUDO apt-get install -y \
    ripgrep \
    fd-find \
    git \
    curl \
    npm \
    build-essential

# Neovim 0.11.3 をインストール
cd /tmp
curl -LO https://github.com/neovim/neovim/releases/download/v0.11.3/nvim-linux-arm64.tar.gz
$SUDO tar -xzf nvim-linux-arm64.tar.gz -C /usr/local --strip-components=1
rm nvim-linux-arm64.tar.gz

# pyright (Python LSP) をインストール
$SUDO npm install -g pyright

# Neovim設定をシンボリックリンク
mkdir -p ~/.config
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim

echo "✅ Done! Run 'nvim' to start"
