#!/usr/bin/env zsh
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


### FIXES
case "$(uname -s)" in
  Darwin)
    # fix macos tempdir permission issue
    #   https://github.com/jesseduffield/lazygit/issues/4924
    TMPDIR=$(getconf DARWIN_USER_TEMP_DIR)
    ;;
esac


### ZSH PROMPT
if command -v oh-my-posh &>/dev/null && [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  ## OHMYPOSH
  znap eval omp "oh-my-posh init zsh --config $DOTFILES/themes/tokyonights.omp.toml"
else
  ## POWERLEVEL10K
  znap prompt romkatv/powerlevel10k
  # run `p10k configure` to configure, or edit ~/.df/zsh/.p10k.zsh
  [[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
fi

# vim: ft=zsh
