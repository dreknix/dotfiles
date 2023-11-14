# dotfiles

Idea based on [this](
https://medium.com/@augusteo/simplest-way-to-sync-dotfiles-and-config-using-git-14051af8703a)
article.

## Installation

### Clone Dotfiles

Adding new computer

```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git clone --bare git@github.com:dreknix/dotfiles.git $HOME/.cfg
config checkout
config config --local status.showUntrackedFiles no
config config --local user.name "dreknix"
config config --local user.email "dreknix@proton.me"
```

### Adjust local files

* `.gitconfig-user.dist` - General user name and e-mail
* `.gitconfig-local.dist` - Additional Git configurations
* `.shell_common_local.sh.dist` - Additional shell configs

## Additional Configuration

TODO: see wiki for these things

Neovim

```console
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
git clone git@github.com:dreknix/tools-nvchad-config.git ~/.config/nvim/lua/custom
```

### Add SSH Config and Keys

TODO

### Configure host with Ansible

TODO

```console
cd ~/tools/ansible
direnv allow .
pip3 install -r requirements
ansible-playbook site.yml -t user
```

For colors [base16](https://github.com/tinted-theming/base16-shell.git) is used.

```console
git clone https://github.com/tinted-theming/base16-shell.git ~/.config/base16-shell
```

The color scheme can be set by `base16_/theme/`:

```console
base16_catppuccin-mocha
```

TODO: Icons `Arc` see `~/.icons/README.md`

TODO: copy background image

### Configure `gopass`

TODO - see wiki (remove here and at to wiki)

## License

[MIT](https://github.com/dreknix/dotfiles/blob/main/LICENSE)
