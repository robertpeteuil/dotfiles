#!/bin/zsh
# cspell: disable
# shellcheck shell=zsh

## ZSHENV
#
#   A component of https://github.com/robertpeteuil/dotfiles
#


# By default, Zsh will look for dotfiles in $HOME (and find this file)
#   Once $ZDOTDIR is defined it will look there
export DOTFILES="$HOME/.dotfiles"
export ZDOTDIR="$DOTFILES/zsh"
export ZSH_AUTOCOMPLETE_DISABLED=''  # set to disable autocomplete