# dotfiles

## Shell configuration "dotfiles" - cross platform settings, aliases and script

----

Quickly and simply install settings, aliases and functions for Bash and Zsh on Linux, macOS, and WSL Shells.

## Settings

The following configs are installed:

- zsh - configures zsh znap plugin manager, prompt, plugins, aliases
- bash - configured bash settings, bash git prompt
- git - general configuration, aliases, colorization, user settings
- nvim - linked from the external `dotfiles-nvim` clone when present

## Installation

Verify and run the downloader script to clone this repo.

``` bash
$ curl -LO https://raw.githubusercontent.com/robertpeteuil/dotfiles/main/downloader

# review script - e.g. cat downloader

$ chmod +x downloader
$ ./downloader
```

The downloader script performs the following tasks:

- Installs `git` if not installed (required to clone the `dotfiles` repo)
- Clones the main `dotfiles` repo into `~/.dotfiles` by default
- Prints manual next steps

The downloader does not run `./update` automatically. After cloning, review whether additional repos are needed and run `update` manually:

``` bash
$ cd ~/.dotfiles

# Optional: only needed when you want additional split/private repos
$ cp repos.conf.example repos.conf
$ ${EDITOR:-vi} repos.conf

$ ./update
```

If no additional repos are needed, skip the `repos.conf` copy/edit step and run `./update` directly. If `repos.conf` is missing, `update` will create it from `repos.conf.example` when possible, but copied example entries remain commented until you opt in.

`./update` replaces direct `./install` usage. The old `install` script is not part of the supported workflow and will be removed; use `./update` for both repo management and Dotbot linking.

## Additional repos with `repos.conf`

`repos.conf` is a local, gitignored file for additional dotfiles repos only. The main dotfiles repo is inferred from the directory containing `update`.

Copy `repos.conf.example` to `repos.conf` and uncomment/edit entries as needed:

``` bash
REPOS=(
  # "${USER}/dotfiles-nvim external/nvim public shallow"
  # "${USER}/dotfiles-secret secret private shallow"
)
```

Each entry has this format:

``` text
"owner/repo relative_target [repo_access] [clone_depth]"
```

- `owner/repo`: GitHub repo identifier
- `relative_target`: target directory relative to the main dotfiles repo, such as `external/nvim`
- `repo_access`: optional `public`, `private`, or `auto`; default is `auto`
- `clone_depth`: optional `shallow` or `full`; default is `shallow`

Existing split repos from older hardcoded workflows can usually stay in place if their target paths match the new `repos.conf` entries. For example, an existing `external/nvim` clone will be updated in place once the matching `dotfiles-nvim` entry is enabled. Existing repos use their current Git remotes during updates; `repos.conf` repo URLs are used only when cloning missing repos.

## Updating and linking

`update` is the repo-management and Dotbot-linking entrypoint:

``` bash
$ ./update
```

Modes:

- `./update`: update the main repo, manage configured additional repos, then run Dotbot
- `./update --repo` or `./update -r`: update/clone repos only; skip Dotbot linking
- `./update --link` or `./update -l`: run Dotbot only; skip repo and `repos.conf` work
- `./update --repo --link` or `./update -r -l`: full/default mode
- `./update --dev` or `./update -d`: use full-depth clones for missing additional repos unless a repo entry sets its own `clone_depth`
- `./update --help` or `./update -h`: show help without doing repo or Dotbot work

Short flags are not combined; use `-r -l`, not `-rl`.

Dotbot arguments must come after `--`:

``` bash
$ ./update -- --verbose
$ ./update --link -- --verbose
```

Dotbot pass-through arguments after `--` are ignored in repo-only mode because Dotbot does not run.

`update` can be run from any current working directory; it uses the directory containing the `update` script as the main dotfiles repo and as the base for config files and additional repo targets.

`update` runs Dotbot with `install.conf.yaml`, which links shell and config files such as:

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
