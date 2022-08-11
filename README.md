# dotfiles

Idea based on [this](https://medium.com/@augusteo/simplest-way-to-sync-dotfiles-and-config-using-git-14051af8703a) article.

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

### Add SSH Config and Keys

TODO

### Start Ansible

TODO
_
```console
$ cd ~/tools/ansible
$ direnv allow .
$ pip3 install -r requirements
$ ansible-playbook site.yml -t user
```

TODO base16 - Tomorrow Night scheme

For colors [base16](https://github.com/chriskempson/base16) is used.

```bash
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
```

The color scheme can be set by `base16_/theme/`. The current scheme is written
to `~/.base16_theme`
The select the theme in settings.

TODO: Icons `Arc` see `~/.icons/README.md`

TODO: copy background image

### Configure `gopass`

TODO - see wiki

## License

[MIT](https://github.com/dreknix/dotfiles/blob/main/LICENSE)
