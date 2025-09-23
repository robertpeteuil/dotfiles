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

### COMPLETIONS
## jujutsu completion
if command -v jj >/dev/null 2>&1; then
  source <(jj util completion zsh)
  # source <(COMPLETE=zsh jj)   # dynamic completions
fi
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi
## fzf completions
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi
compdef _gnu_generic fzf

### setup NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm

### setup atuin
if [[ -f "$HOME/.atuin/bin/env" ]]; then
  . "$HOME/.atuin/bin/env"
fi
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh)"
fi

### SOURCE FILES
# cross-shell files
[[ ! -f $DOTFILES/shell/includes ]] || source $DOTFILES/shell/includes

### ZSH PROMPT

if command -v oh-my-posh &>/dev/null && [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  ## OHMYPOSH
  eval "$(oh-my-posh init zsh --config $DOTFILES/themes/tokyonights.omp.toml)"
else
  ## POWERLEVEL10K
  znap prompt romkatv/powerlevel10k
  # run `p10k configure` to configure, or edit ~/.df/zsh/.p10k.zsh
  [[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
fi
