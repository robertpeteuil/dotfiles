#!/bin/bash


OS="$(uname -s)"

if [[ "$OS" == 'Darwin' ]]; then

  echo "Use brew to install 'eza', 'zoxide' and 'oh-my-posh' on macOS."

elif [[ "$OS" == 'Linux' ]]; then

  CPU=$(uname -m)
  if [[ "$CPU" == "x86_64" ]]; then
    ARCH="x86_64"
  elif [[ "$CPU" == "aarch64" ]]; then
    ARCH="aarch64"
  fi

  if ! command -v eza &>/dev/null; then
    echo "eza is not installed. Installing..."
    file_url="https://github.com/eza-community/eza/releases/latest/download/eza_${ARCH}-unknown-linux-gnu.tar.gz"
    # wget -c "$file_url" -O - | tar xz
    curl -sL "$file_url" | tar xz
    chmod +x eza
  	sudo mv eza /usr/local/bin/eza
  fi

  if ! command -v zoxide &>/dev/null; then
    echo "zoxide is not installed. Installing..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  fi

  if ! command -v oh-my-posh &>/dev/null; then
    echo "oh-my-posh is not installed. Installing..."
    curl -s https://ohmyposh.dev/install.sh | bash -s
  fi

fi
