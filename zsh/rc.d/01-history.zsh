#!/bin/zsh
# cspell: disable
# shellcheck shell=zsh

## HISTORY
#   Set these first so history is preserved
#
#   A component of https://github.com/robertpeteuil/dotfiles
#


# Enable additional glob operators. (Globbing = pattern matching)
setopt EXTENDED_GLOB

# Tell zsh where to store history.
HISTFILE=$ZDOTDIR/history

# Just in case: If the parent directory doesn't exist, create it.
[[ -d $HISTFILE:h ]] || mkdir -p $HISTFILE:h

# Max number of entries to keep in history file.
SAVEHIST=$(( 100 * 1000 ))      # Use multiplication for readability.

# Max number of history entries to keep in memory.
HISTSIZE=$(( 1.2 * SAVEHIST ))  # Zsh recommended value

# Use modern file-locking mechanisms, for better safety & performance.
setopt HIST_FCNTL_LOCK

# Keep only the most recent copy of each duplicate entry in history.
setopt HIST_IGNORE_ALL_DUPS

# Auto-sync history between concurrent sessions.
setopt SHARE_HISTORY