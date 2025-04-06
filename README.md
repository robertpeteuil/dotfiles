# dotfiles

## Shell configuration "dotfiles" - cross platform settings, aliases and script

----

Quickly and simply install settings, aliases and functions for Bash and Zsh on Linux, macOS, and WSL Shells.

## Settings

The following configs are installed:

- zsh - configures zsh znap plugin manager, prompt, plugins, aliases
- bash - configured bash settings, bash git prompt
- git - general configuration, aliases, colorization, user settings

## Installation

Verify and run downloader script to download/install

``` bash
$ curl -LO https://raw.githubusercontent.com/robertpeteuil/dotfiles/main/downloader

# review script - e.g. cat downloader

$ chmod +x downloader
$ ./downloader
```

The downloader script performs the following tasks:

- Install `git` if not installed (required to clone the `dotfiles` repo)
- Clones `dotfiles` repo into the `~/.dotfiles` directory (configurable)
- Clones `dotfiles-private` repo into the `~/.dotfiles/private` directory (configurable)
- executes included `install` script

Install script performs actions from `install.conf.yaml`

- ZSH
  - symlinks `zshenv` to $HOME
- Bash
  - symlinks `bashrc` and `bash_profile` to $HOME
  - symlinks `bash-git-prompt` and `grc` for bash prompt/colorization
- Git config
  - symlinks `gitconfig`, `gitignore_global`
  - symlinks `gitconfig_ssh` (url specific overrides)

## Load details

### ZSH dotfiles load process

- `.zshenv` read from $HOME, sets $ZDOTDIR
- `.zshrc` read from $ZDOTDIR directory
- `.zshrc` sources the following
  - `$HOME/.cache/p10k-insta-prompt` if present
  - files in `$ZDOTDIR/rc.d`
    - 01 - history
    - 02 - znap install
    - 04 - Env and Path
    - 06 - prompt setup
    - 08 - plugins
      - `marlonrichert/zcolors`           # colors for completions and git
      - `zsh-users/zsh-autosuggestions`   # Inline suggestions
      - `zdharma-continuum/fast-syntax-highlighting`
      - `zsh-users/zsh-completions`
      - `marlonrichert/zsh-autocomplete`  # type-ahead completion
    - 10 - options
    - 12 - keys
    - 20 - zsh specific aliases
      - configure zsh dirstack, reload, zshrc edits, showcolors, zmv
  - sources `DOTFILES/shell/includes` which includes
    - `DOTFILES/shell/aliases` - cross-shell (used by both bash & zsh)
    - `DOTFILES/shell/functions` - cross-shell (used by both bash & zsh)
    - optional files

### Bash dotfiles load process

- `.bash_profile` - loaded by bash login shell
  - sources `.bashrc`
- `.bashrc` - loaded by non-login shells (unless sourced explicitly)
  - exits if non-interactive or not bash
  - sets paths
  - sets prompt, colors
  - configured brew PATH
  - configures GRC
  - display linux reboot message, if appropriate
  - sources `DOTFILES/shell/includes` which includes
    - `DOTFILES/shell/aliases` - cross-shell (used by both bash & zsh)
    - `DOTFILES/shell/functions` - cross-shell (used by both bash & zsh)
    - optional files

## Customization

Customize this repo by forking it and customizing to your needs.

- This repo uses [dotbot](https://github.com/anishathalye/dotbot) bootstrap
- [Configuration Info](https://github.com/anishathalye/dotbot#configuration)
- [Dotbot Wiki](https://github.com/anishathalye/dotbot/wiki)
