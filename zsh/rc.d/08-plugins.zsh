#!/bin/zsh
# cspell: disable
# shellcheck shell=zsh

## PLUGINS
#
#   A component of https://github.com/robertpeteuil/dotfiles
#


local -a plugins=(
    zsh-users/zsh-autosuggestions               # Inline suggestions
    zdharma-continuum/fast-syntax-highlighting  # Fast syntax highlighting
    zsh-users/zsh-completions                   # 
    marlonrichert/zsh-autocomplete              # Real-time type-ahead completion
    marlonrichert/zcolors                       # Colors for completions and Git
)
# Other plugins:
#     jeffreytse/zsh-vi-mode                      # https://github.com/jeffreytse/zsh-vi-mode
#     marlonrichert/zsh-edit                    # Better keyboard shortcuts
#     marlonrichert/zsh-hist                    # Edit history from the command line.
#     zsh-users/zsh-syntax-highlighting         # Command-line syntax highlighting


# Clone new plugins in parallel
znap clone $plugins

local p=
for p in $plugins; do
  znap source $p
done

# Load zcolors
znap eval zcolors zcolors   # Extra init code needed for zcolors.
