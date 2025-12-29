#!/bin/bash
set -e

echo "🚀 Setting up Neovim environment..."

# 必要なパッケージをインストール
sudo apt-get update
sudo apt-get install -y \
    neovim \
    ripgrep \
    fd-find \
    git \
    curl \
    npm \
    build-essential

# pyright (Python LSP) をインストール
sudo npm install -g pyright

# Neovim設定をシンボリックリンク
mkdir -p ~/.config
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim

echo "✅ Done! Run 'nvim' to start"
