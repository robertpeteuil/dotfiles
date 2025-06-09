#!/bin/bash

OS="$(uname -s)"

if [[ "$OS" == 'Linux' ]]; then

  CPU=$(uname -m)

  echo "CPU: $CPU"

  if [[ "$CPU" == "x86_64" ]]; then
      ARCH="x86_64"
  elif [[ "$CPU" == "aarch64" ]]; then
      ARCH="arm64"
  fi

  echo "ARCH: $ARCH"

  if ! command -v lazygit &>/dev/null; then
      echo "lazygit is not installed. Installing..."
      LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')

      echo "LAZYGIT VERSION: $LAZYGIT_VERSION"

      curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${ARCH}.tar.gz"
      tar xf lazygit.tar.gz lazygit
      # sudo install lazygit -D -t /usr/local/bin/
      chmod +x lazygit
      sudo mv lazygit /usr/local/bin/lazygit
  fi
fi

