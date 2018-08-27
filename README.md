# dotfiles

## Shell configuration "dotfiles" - cross platform settings, aliases and utilities

----

Quickly and simply install settings, packages, aliases and functions on Linux, macOS, and Windows Linux Shells.

### Installation

``` bash
$ curl iac.sh/dotfiles | sh
```

For enhanced security, use `https` and verify the script's SHA checksum is `dc4701d7eb9cd58a3717fce6cc13f687aa89c27d6ecb58ceeaa9d8e27129ccfe`.

``` bash
# retrieve SHA of the script and verify it matches above listed SHA
$ curl https://iac.sh/dotfiles | shasum -a 256
# after verifying the SHA, run the installer over https
$ curl https://iac.sh/dotfiles | sh
```

The installation script performs the following tasks:

- Install `git` if not installed (required to clone the `dotfiles` repo)
- On Linux, installs `python-distutils` (for Python2) or `python3-distutils` (for Python3)
- Clones the `dotfiles` repo into the `~/.dotfiles` directory
- Install platform specific dotfiles configurations
  - symlinks settings, aliases and settings files
  - install packages and sym-link files

### Usage

Customize this repo by forking it and customizing to your needs.

- This repo uses [dotbot](https://github.com/anishathalye/dotbot) bootstrap
- [Configuration Info](https://github.com/anishathalye/dotbot#configuration)
- [Dotbot Wiki](https://github.com/anishathalye/dotbot/wiki)
