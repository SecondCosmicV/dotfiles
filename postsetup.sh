#!/usr/bin/env bash

set -x
dconf write /org/gtk/settings/file-chooser/show-hidden true
nmcli connection import type wireguard file ~/stuff/vpn/vpn.conf
until ping -c1 google.com; do
    sleep 1
done
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.signal.Signal
flatpak install flathub com.discordapp.Discord
flatpak install flathub com.spotify.Client
cd ~/stuff/secrets
stow -R -t ~ .

