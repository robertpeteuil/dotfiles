#!/bin/bash

OS="$(uname -s)"

if [[ "$OS" == 'Darwin' ]]; then
  echo "enabling move window with <cmd> + <ctrl> + click"

  defaults write -g NSWindowShouldDragOnGesture -bool true
  defaults write -g NSWindowShouldDragOnGestureFeedback -bool false

  echo "must restart to enable"
fi
