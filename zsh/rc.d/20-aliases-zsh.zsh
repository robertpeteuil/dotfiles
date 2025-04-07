#!/bin/zsh
# cspell: disable
# shellcheck shell=zsh

## ZSH SPECIFIC ALIASES AND COMMANDS
#
#   A component of https://github.com/robertpeteuil/dotfiles
#


## ZSH COLORS
autoload -U colors && colors

## ZSH DIRECTORY STACK
#  https://thevaluable.dev/zsh-install-configure-mouseless/
#  https://zsh.sourceforge.io/Intro/intro_6.html
#  https://zsh.sourceforge.io/Doc/Release/Directory-Stack.html
DIRSTACKSIZE=15
setopt AUTO_PUSHD           # Push the current directory visited on the stack
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd
# setopt PUSHD_MINUS        # set top of the stack to current dir When using pushd
alias dh='dirs -v | tail -n 12'   # conflicted with docker alias (turned off dock alias)
for index ({1..12}) alias "$index"="cd +${index}"; unset index

## AUTOCD - change dir without having to type `cd`, just type its name
# This can misfire if an alias, # function, builtin or command has the same name.
# Only recommend using these without `cd`:
#   ..  to go one dir up
#   ~   to go to your home dir
#   ~-2 to go to the 2nd mostly recently visited dir
#   /   to go to the root dir
# setopt AUTO_CD

## ZSH SPECIFIC ALIASES
alias reload='exec zsh'   # alias reload='omz reload'
alias zshrc='${=EDITOR} ${ZDOTDIR:-$HOME}/.zshrc'
alias which-command=whence
alias %= \$=   # Enable pasting text with prompt symbols
alias showcolors='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done'

## ZMV
#   batch rename/copy/link files with pattern matching.
autoload -Uz zmv
alias zmv='zmv -Mv'
alias zcp='zmv -Cv'
alias zln='zmv -Lv'

# SET $PAGER
#   `:` is a builtin command that does nothing. We use it here to stop Zsh from
#   evaluating the value of our $expansion as a command.
: ${PAGER:=less}

# ASSOCIATE FILE EXTENSIONS WITH PROGRAMS
#   This lets you open a file just by typing its name and pressing enter.
#   Note that the dot is implicit; `gz` below stands for files ending in .gz
alias -s {css,gradle,html,js,json,md,patch,properties,txt,xml,yml}=$PAGER
alias -s gz='gzip -l'
alias -s {log,out}='tail -F'

# USE `< file` TO VIEW ANY TEXT FILE
READNULLCMD=$PAGER  # Set the program to use for this.
