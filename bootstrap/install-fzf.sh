#!/bin/bash

if ! command -v fzf &>/dev/null; then
  echo "fzf is not installed. Installing..."
  curl -sSfL https://raw.githubusercontent.com/junegunn/fzf/master/install | bash
else
  echo "fzf already installed."
fi
