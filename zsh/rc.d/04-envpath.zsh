#!/bin/zsh
# cspell: disable
# shellcheck shell=zsh

## ENVIRONMENTS & PATHS
#
#   A component of https://github.com/robertpeteuil/dotfiles
#


## NAMED DIRECTORIES
#   Create shortcuts for your favorite directories.
#   Set early as it affects how dirs are displayed and printed.
# `hash -d <name>=<path>` makes ~<name> a shortcut for <path>.
#   You can use this ~name anywhere you would specify a dir, not just with `cd`!
# hash -d zsh=$ZDOTDIR
# hash -d git=$gitdir

## PATH
#   -U discards duplicates, -T creates a "tied" pair
#   $PATH and $path (and also $FPATH and $fpath, etc.) are "tied" to each other.
export -U PATH path FPATH fpath MANPATH manpath
export -UT INFOPATH infopath 

# PATH - OS SPECIFIC
if [ "$(uname -s)" = "Darwin" ]; then
    path=(
        /usr/local/bin
        $path
    )
elif [ "$(uname -s)" = "Linux" ]; then
    path=(
        $path
        ~/.local/bin
    )
fi

## FUNCTION PATH
#   $FPATH and $fpath dirs are where zsh looks for functions.
fpath=(
    $ZDOTDIR/functions
    $fpath
    ~/.local/share/zsh/site-functions
)

## BREW ENVIRONMENT    
if [[ -r "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -r "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi
