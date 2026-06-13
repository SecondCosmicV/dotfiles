#!/usr/bin/env bash

set -x
dconf write /org/gtk/settings/file-chooser/show-hidden true
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.discordapp.Discord
flatpak install flathub com.spotify.Client
cd ~/stuff/secrets
stow -R -v -t ~ .

