#!/bin/zsh
# cspell: disable
# shellcheck shell=zsh

## PLUGINS
#
#   A component of https://github.com/robertpeteuil/dotfiles
#


local -a plugins=(
    marlonrichert/zcolors                       # Colors for completions and Git
    zsh-users/zsh-autosuggestions               # Inline suggestions
    zdharma-continuum/fast-syntax-highlighting  # Fast syntax highlighting
    zsh-users/zsh-completions                   # 
    marlonrichert/zsh-autocomplete              # Real-time type-ahead completion
)
# Other plugins:
#     marlonrichert/zsh-edit                    # Better keyboard shortcuts
#     marlonrichert/zsh-hist                    # Edit history from the command line.
#     zsh-users/zsh-syntax-highlighting         # Command-line syntax highlighting


# DELAY AUTOCOMPLETE WHEN CONNECTED VIA SSH
if [ -n "$SSH_CONNECTION" ]; then
    echo "Running in an SSH session - delaying autocomplete"
    zstyle ':autocomplete:*' min-delay 0.5  # seconds
fi


# Clone new plugins in parallel
znap clone $plugins

local p=
for p in $plugins; do
  znap source $p
done

# Load zcolors
znap eval zcolors zcolors   # Extra init code needed for zcolors.