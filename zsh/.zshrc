#!/bin/zsh
# cspell: disable
# shellcheck shell=zsh

## ZSH RC
#
#   A component of https://github.com/robertpeteuil/dotfiles
#


### AUTO-COMPILE
zstyle ':znap:*' auto-compile yes

### RUN .ZLOGOUT WHEN SHELL IS CLOSED 
function shellExit {
  [[ -f $ZDOTDIR/.zlogout ]] && . $ZDOTDIR/.zlogout
}
trap shellExit EXIT

### ENABLE POWERLEVEL10K INSTANT PROMPT
#   Keep near top of ~/.df/zsh/.zshrc, but before any console I/O
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### AUTOCOMPLETE ADJUSTMENTS
# Delay autocomp display
#   1 sec delay on ssh connecteions
if [ -n "$SSH_CONNECTION" ]; then
    zstyle ':autocomplete:*' min-delay 1  # seconds
fi
#   2.5 sec delay if ~/.slowzshcomp exists
if [ -f $HOME/.slowzshcomp ]; then
    zstyle ':autocomplete:*' min-delay 2.5
fi
# Disable if ZSH_AUTOCOMPLETE_DISABLED or ~/.hushzshcomp exists
if [ -n "$ZSH_AUTOCOMPLETE_DISABLED" ] || [ -f $HOME/.hushzshcomp ]; then
    zstyle ':autocomplete:*' async no
fi

### LOAD FILES IN RC.D DIR
# load files that start with integers and end in `.zsh`
#   (n) sorts the results in numerical order
#   <->  matches any non-negative integer
() {
  local gitdir=$ZDOTDIR/repos  # where to keep repos and plugins
  local file=
  for file in $ZDOTDIR/rc.d/<->-*.zsh(n); do
    . $file
  done
} "$@"

### LOAD ZSH FUNCTIONS
autoload -Uz pathIf sourceIf

### SOURCE FILES
# cross-shell files
[[ ! -f $DOTFILES/shell/includes ]] || source $DOTFILES/shell/includes
# prompt configuration
#   run `p10k configure` to configure, or edit ~/.df/zsh/.p10k.zsh
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh