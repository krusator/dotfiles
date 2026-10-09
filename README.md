# here are my dotfiles

they can be managed on a machine using gnu stow with the following commands:

```sh
stow -t ~ nvim zshrc tmux kitty tools ghostty starship
```

on macOS you can also use the installer script:

```sh
./install.sh
```

## Requirements

* [Homebrew](https://brew.sh/) (for macOS)
* [GNU Stow](https://www.gnu.org/software/stow/)
* [Starship](https://starship.rs/) (default `zshrc` prompt; set `ZSH_PROMPT_ENGINE=p10k` to use Powerlevel10k instead)
