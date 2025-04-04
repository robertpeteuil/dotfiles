#!/bin/zsh
# cspell: disable
# shellcheck shell=zsh

## INSTALL AND LOAD ZNAP PLUGIN MANAGER
#
#   A component of https://github.com/robertpeteuil/dotfiles
#


local repodir=$ZDOTDIR/repos
local znapdir=$ZDOTDIR/repos/zsh-snap
local znapscript=$ZDOTDIR/repos/zsh-snap/znap.zsh

# Auto-install Znap if necessary
if ! [[ -r $znapscript ]]; then
  mkdir -p $znapdir
  git -C $repodir clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git
fi

# Load Znap
. $znapscript                     
