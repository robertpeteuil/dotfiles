#!/usr/bin/env zsh
# cspell: disable
# shellcheck shell=zsh

### INITS & COMPLETIONS 
#
#   A component of https://github.com/robertpeteuil/dotfiles
#
#   requires: pathIf(fn)

# jujutsu completion
if command -v jj >/dev/null 2>&1; then
  znap function _jj jj 'source <(jj util completion zsh)'
  compctl -K _jj jj
fi

# zoxide init
if command -v zoxide >/dev/null 2>&1; then
  znap eval zoxide "zoxide init --cmd cd zsh"
fi

# fzf completion
if command -v fzf >/dev/null 2>&1; then
  # on-demand completion
  znap function _fzf fzf 'eval "$(fzf --zsh)"; compdef _gnu_generic fzf'
  compctl -K _fzf fzf
fi

# atuin init
if [[ -f "$HOME/.atuin/bin/env" ]]; then
  . "$HOME/.atuin/bin/env"
fi

# atuin completion
if command -v atuin &>/dev/null; then
  # eval "$(atuin init zsh)"
  znap eval atuin "atuin init zsh"
fi

# mise init and completion
if command -v mise &>/dev/null; then
  znap eval mise "mise activate zsh"
  # on-demand completion
  znap function _mise mise 'eval "$(mise completion zsh)"'
  compctl -K _mise mise
fi

# television completion
if command -v tv &>/dev/null; then
  znap eval tv "tv init zsh"
fi

# obsidian cli path
pathIf "/Applications/Obsidian.app/Contents/MacOS"


# vim: ft=zsh
