# dotfiles

## Shell configuration "dotfiles" - cross platform settings, aliases and script

----

Quickly and simply install settings, aliases and functions for Bash and Zsh on Linux, macOS, and WSL Shells.

### Settings

The following configs are installed:

- zsh - configures zsh znap plugin manager, prompt, plugins, aliases
- bash - configured bash settings, bash git prompt
- git - general configuration, aliases, colorization, user settings

### Installation

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
  - `zshrc`, `zlogout`, and all files in `zsh/rc.d` loaded by zsh
  - installs `znap` plugin manager (on first use)
  - installs & sources plugins defined in `zsh/rc.d/08-plugins`
- Bash
  - symlinks `bashrc` and `bash_prpfile` to $HOME
  - symlinks `bash-git-prompt` and `grc` for bash prompt/colorization
- Git config
  - symlinks `gitconfig`, `gitignore_global`
  - symlinks `gitconfig_ssh` (url specific overrides)

### Customization

Customize this repo by forking it and customizing to your needs.

- This repo uses [dotbot](https://github.com/anishathalye/dotbot) bootstrap
- [Configuration Info](https://github.com/anishathalye/dotbot#configuration)
- [Dotbot Wiki](https://github.com/anishathalye/dotbot/wiki)
