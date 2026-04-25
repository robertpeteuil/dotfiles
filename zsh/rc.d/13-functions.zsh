#!/usr/bin/env zsh
# cspell: disable
# shellcheck shell=zsh

##  FUNCTIONS
#
#   A component of https://github.com/robertpeteuil/dotfiles
#

## LOAD ZSH FUNCTIONS
autoload -Uz pathIf sourceIf


### DEFINE PERSONAL UPDATE FUNCTIONS

update-set-colors() {
  RED="\e[31m"
  GREEN="\e[32m"
  WHITE="\e[0m"
  BLUE="\e[34m"
}

update-apps() {
  OS=$(uname -s)
  update-set-colors
  if [[ "$OS" == 'Darwin' ]]; then
    # Update Mac App Store Apps when NOT connected over SSH, may require UI action
    if [[ -z "$SSH_CLIENT" ]] && [[ -z "$SSH_TTY" ]] && [[ -z "$SSH_CONNECTION" ]]; then
      if mas &>/dev/null; then
        echo -e "${BLUE}Updating Mac App Store apps${WHITE}..."
        mas upgrade
      fi
    fi
  fi
}

update-packages() {
  OS=$(uname -s)
  update-set-colors
  # Update Packages - MacOS
  if [[ "$OS" == 'Darwin' ]]; then
    # Update macos packages via brew
    if brew --prefix &>/dev/null; then
      export HOMEBREW_NO_ENV_HINTS=1
      echo -e "${BLUE}Updating via brew${WHITE}..."
      brew update && brew upgrade
      # perform clean unless 'noclean' specific
      if [[ "$1" != "noclean" ]]; then
        echo -e "${BLUE}Cleaning brew packages${WHITE}..."
        brew cleanup 2>/dev/null
      fi
    fi
  # Update Packages - Linux
  elif [[ "$OS" == 'Linux' ]]; then
    # Determine linux package manager
    if apt-get &>/dev/null; then
      pkg_cmd="apt-get"
    elif apt -h &>/dev/null; then
      pkg_cmd="apt"
    elif yum -h &>/dev/null; then
      pkg_cmd="yum"
    fi
    # Update Linux packages
    if [[ "$pkg_cmd" == apt* ]]; then
      echo -e "${BLUE}Updating via ${pkg_cmd}${WHITE}..."
      sudo "${pkg_cmd}" update -qq -y
      echo -e "${BLUE}Upgrading via ${pkg_cmd}${WHITE}..."
      sudo "${pkg_cmd}" upgrade -y
      # perform clean unless 'noclean' specific
      if [[ "$1" != "noclean" ]]; then
        echo -e "${BLUE}Autoclean & Autoremove${WHITE}..."
        sudo apt-get autoclean -qq
        sudo apt-get autoremove -qq
      fi
    elif [[ "$pkg_cmd" == "yum" ]]; then
      echo -e "${BLUE}Updating via ${pkg_cmd}${WHITE}..."
      sudo yum makecache fast
      sudo yum update -y
      # perform clean unless 'noclean' specific
      if [[ "$1" != "noclean" ]]; then
        echo -e "${BLUE}Clean & Expire Cache${WHITE}..."
        sudo yum clean packages expire-cache
      fi
    else
      echo -e "${RED}Unknown Package Manager - Packages not updated${WHITE}"
    fi
  else
    echo -e "${RED}Unknown OS - Packages not updated${WHITE}"
  fi
}

update-dotfiles() {
  update-set-colors
  git --version &>/dev/null && GIT_INST=1 || GIT_INST=0
  # update dotfiles
  if [[ -e "$DOTFILES/.git" ]] && [[ -n $GIT_INST ]]; then
    prev_dir=$(pwd)
    echo -e "${BLUE}Updating DOTFILES repo${WHITE}..."
    cd "$DOTFILES" || return
    git up
    cd "$prev_dir" || return
    # check for private repo and update if found
    if [[ -e "$DOTFILES/private/.git" ]]; then
      echo -e "${BLUE}Updating private DOTFILES repo${WHITE}..."
      cd "$DOTFILES/private" || return
      git up
      cd "$prev_dir" || return
    fi
  fi
}

update-code() {
  update-set-colors
  if which code &>/dev/null; then
    echo -e "${BLUE}Updating VSCode Extensions${WHITE}..."
    code --update-extensions 2>/dev/null
  fi
}

update-all() {
  update-packages "$1"
  # update-apps
  update-dotfiles
}

# vim: ft=zsh
