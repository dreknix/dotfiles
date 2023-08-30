# Hack Nerd Font

## Download and Install

```console
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/HackNerdFontMono-Regular.ttf
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf

wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Italic/HackNerdFontMono-Italic.ttf
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Italic/HackNerdFont-Italic.ttf

wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Bold/HackNerdFontMono-Bold.ttf
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Bold/HackNerdFont-Bold.ttf

wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/BoldItalic/HackNerdFontMono-BoldItalic.ttf
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/BoldItalic/HackNerdFont-BoldItalic.ttf
```

Copy the font files into `~/.local/share/fonts/`.

If the directory is not automatically parsed:

```bash
$ fc-cache -f -v
```

Check if the font is found:

```bash
$ fc-list | grep "Hack"
```

## Configure

```bash
gsettings set org.gnome.desktop.interface font-name 'Hack Nerd Font 11'
gsettings set org.gnome.desktop.interface document-font-name 'Hack Nerd Font 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Hack Nerd Font Mono 14'
```
