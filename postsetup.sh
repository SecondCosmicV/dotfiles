#!/usr/bin/env bash

dconf write /org/gtk/settings/file-chooser/show-hidden true
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.signal.Signal
flatpak install flathub com.discordapp.Discord
flatpak install flathub com.spotify.Client
sudo nmcli connection import type wireguard file /mnt/data/stuff/vpn/vpn.conf

