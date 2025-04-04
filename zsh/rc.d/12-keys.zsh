#!/bin/zsh
# cspell: disable
# shellcheck shell=zsh

## KEY BINDINGS
#
#   A component of https://github.com/robertpeteuil/dotfiles
#


# Enable the use of Ctrl-Q and Ctrl-S for keyboard shortcuts.
unsetopt FLOW_CONTROL

# Alt-Q
# - On the main prompt: Push aside your current command line, so you can type a
#   new one. The old command line is re-inserted when you press Alt-G or
#   automatically on the next command line.
# - On the continuation prompt: Move all entered lines to the main prompt, so
#   you can edit the previous lines.
bindkey '^[q' push-line-or-edit

# Alt-H: Get help on your current command.
() {
  unalias $1 2> /dev/null   # Remove the default.

  # Load the more advanced version.
  # -R resolves the function immediately, so we can access the source dir.
  autoload -RUz $1

  # Load $functions_source, an associative array (a.k.a. dictionary, hash table
  # or map) that maps each function to its source file.
  zmodload -F zsh/parameter p:functions_source

  # Lazy-load all the run-help-* helper functions from the same dir.
  autoload -Uz $functions_source[$1]-*~*.zwc  # Exclude .zwc files.
} run-help

# Alt-V: Show the next key combo's terminal code and state what it does.
bindkey '^[v' describe-key-briefly

# Alt-W: Type a widget name and press Enter to see the keys bound to it.
# Type part of a widget name and press Enter for autocompletion.
bindkey '^[w' where-is

# Alt-Shift-S: Prefix the current or previous command line with `sudo`.
() {
  bindkey '^[S' $1  # Bind Alt-Shift-S to the widget below.
  zle -N $1         # Create a widget that calls the function below.
  $1() {            # Create the function.
    # If the command line is empty or just whitespace, then first load the
    # previous line.
    [[ $BUFFER == [[:space:]]# ]] &&
        zle .up-history

    # $LBUFFER is the part of the command line that's left of the cursor. This
    # way, we preserve the cursor's position.
    LBUFFER="sudo $LBUFFER"
  }
} .sudo

## AUTOCOMPLETE HOTKEYS
#   https://github.com/marlonrichert/zsh-autocomplete/blob/main/README.md#key-bindings
#   https://github.com/marlonrichert/zsh-autocomplete?tab=readme-ov-file#reassign-keys
#
# TAB
# option 1 - Tab and ShiftTab cycle through listed completions, don't change whats listed in the menu
# bindkey              '^I'         menu-complete
# bindkey "$terminfo[kcbt]" reverse-menu-complete
# option 2 - Tab and ShiftTab enter the menu instead of inserting a completion
bindkey              '^I' menu-select
bindkey "$terminfo[kcbt]" menu-select
# option 3 - Tab and ShiftTab move the selection in the menu right and left instead of exiting the menu
# bindkey -M menuselect              '^I'         menu-complete
# bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete
#
# ARROW KEYS - always move the cursor on the command line, even when you are in the menu
# bindkey -M menuselect  '^[[D' .backward-char  '^[OD' .backward-char
# bindkey -M menuselect  '^[[C'  .forward-char  '^[OC'  .forward-char
#
# ENTER - always submit the command line, even when you are in the menu
# bindkey -M menuselect '^M' .accept-line