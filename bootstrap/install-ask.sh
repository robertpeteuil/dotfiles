#!/bin/bash

if ! command -v ask &>/dev/null; then
  echo "installing ask"
  curl -sSfL https://raw.githubusercontent.com/kagisearch/ask/main/ask > ./ask
  chmod +x ./ask
  if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
    echo "moving ask to ~/.local/bin (~/.local/bin in PATH)"
    mv ./ask $HOME/.local/bin/ask
  else
    echo "moving ask to /usr/local/bin (no ~/.local/bin)"
    sudo mv ./ask /usr/local/bin/ask
  fi
fi
