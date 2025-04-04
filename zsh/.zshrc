
#!/bin/zsh
# cspell: disable
# shellcheck shell=zsh

## ZSH RC
#
#   A component of https://github.com/robertpeteuil/dotfiles
#


## AUTO-COMPILE
zstyle ':znap:*' auto-compile yes

## RUN .ZLOGOUT WHEN SHELL IS CLOSED 
function shellExit {
  [[ -f $ZDOTDIR/.zlogout ]] && . $ZDOTDIR/.zlogout
}
trap shellExit EXIT

## ENABLE POWERLEVEL10K INSTANT PROMPT
#   Keep near top of ~/.df/zsh/.zshrc, but before any console I/O
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### LOAD FILES IN RC.D DIR
#   load files that start with integers and end in `.zsh`
#     (n) sorts the results in numerical order
#     <->  matches any non-negative integer
() {
  local gitdir=$ZDOTDIR/repos  # where to keep repos and plugins
  local file=
  for file in $ZDOTDIR/rc.d/<->-*.zsh(n); do
    . $file
  done
} "$@"

### SOURCE FILES

# Source common includes file
[[ ! -f $DOTFILES/shell/includes ]] || source $DOTFILES/shell/includes

#   run `p10k configure` to configure, or edit ~/.df/zsh/.p10k.zsh
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh