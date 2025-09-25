#!/bin/bash


OS="$(uname -s)"

if [[ "$OS" == 'Darwin' ]]; then

  if command -v brew &>/dev/null; then
    echo "installing eza, lazygit, zoxide, jqp and oh-my-posh with 'brew'..."
    brew install eza lazygit zoxide oh-my-posh jqp
  else
    echo "brew missing... utils not installed"
    exit 1
  fi

elif [[ "$OS" == 'Linux' ]]; then

  CPU=$(uname -m)
  if [[ "$CPU" == "x86_64" ]]; then
    ARCH_EZA="x86_64"
    ARCH_LAZYGIT="x86_64"
  elif [[ "$CPU" == "aarch64" ]]; then
    ARCH_EZA="aarch64"
    ARCH_LAZYGIT="arm64"
  fi

  if ! command -v eza &>/dev/null; then
    echo "eza is not installed. Installing..."
    file_url="https://github.com/eza-community/eza/releases/latest/download/eza_${ARCH_EZA}-unknown-linux-gnu.tar.gz"
    curl -sL "$file_url" | tar xz
    chmod +x eza
    sudo mv eza /usr/local/bin/eza
  else
    echo "eza already installed."
  fi

  if ! command -v lazygit &>/dev/null; then
    echo "lazygit is not installed. Installing..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
    echo "LAZYGIT VERSION: $LAZYGIT_VERSION"

    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${ARCH_LAZYGIT}.tar.gz"
    tar xf lazygit.tar.gz lazygit
    chmod +x lazygit
    sudo mv lazygit /usr/local/bin/lazygit
  else
    echo "lazygit already installed."
  fi

  if ! command -v zoxide &>/dev/null; then
    echo "zoxide is not installed. Installing..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  else
    echo "zoxide already installed."
  fi

  if ! command -v oh-my-posh &>/dev/null; then
    echo "oh-my-posh is not installed. Installing..."
    curl -s https://ohmyposh.dev/install.sh | bash -s
  else
    echo "oh-my-posh already installed."
  fi

fi
