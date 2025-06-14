#!/bin/bash

if ! command -v uv &>/dev/null; then
  echo "installing uv"
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
