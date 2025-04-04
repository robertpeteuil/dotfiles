# dotfiles

## Shell configuration "dotfiles" - cross platform settings, aliases and script

----

Quickly and simply install settings, aliases and functions for Bash and Zsh on Linux, macOS, and WSL Shells.

### Installation

For enhanced security use `https` and verify script before running installer

``` bash
$ curl https://iac.sh/dotfiles > downloader

# review script - e.g. cat downloader

$ chmod +x downloader
$ ./downloader
```

The installation script performs the following tasks:

- Install `git` if not installed (required to clone the `dotfiles` repo)
- On Linux, installs `python3-distutils`
- Clones the `dotfiles` repo into the `~/.dotfiles` directory
- Install platform specific dotfiles configurations
  - symlinks settings, aliases and settings files
  - installs and symlink scripts

### Usage

Customize this repo by forking it and customizing to your needs.

- This repo uses [dotbot](https://github.com/anishathalye/dotbot) bootstrap
- [Configuration Info](https://github.com/anishathalye/dotbot#configuration)
- [Dotbot Wiki](https://github.com/anishathalye/dotbot/wiki)
