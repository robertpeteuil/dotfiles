#!/bin/bash

if ! command -v atuin &>/dev/null; then
  echo "atuin is not installed. Installing..."
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
else
  echo "atuin already installed."
fi
