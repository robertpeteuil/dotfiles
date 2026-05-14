#!/usr/bin/env zsh
# cspell: disable
# shellcheck shell=zsh
# shellcheck disable=SC1090

## INCLUDE EXTERNAL DOTFILES
#
#   A component of https://github.com/robertpeteuil/dotfiles
#
#   requires: sourceIf(fn)


sourceIf "$DOTFILES/private/shell/aliases-private"  # private-aliases  - zsh & bash
sourceIf "$DOTFILES/private/shell/env-private"      # private env vars - zsh & bash
sourceIf "$HOME/.localrc"
sourceIf "$HOME/.workrc"

# vim: ft=zsh
