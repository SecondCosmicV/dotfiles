#!/usr/bin/env bash

set -x
dconf write /org/gtk/settings/file-chooser/show-hidden true
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.discordapp.Discord
flatpak install flathub com.spotify.Client
cd ~/stuff/secrets
stow -R -v -t ~ .
mkdir -p ~/stuff/roots
rm -f ~/stuff/roots/yt-dlp
guix shell -r ~/stuff/roots/yt-dlp \
    nss-certs \
    openssl \
    python-yt-dlp \
    -- \
    true
rm -f ~/stuff/roots/cursor
guix shell -r ~/stuff/roots/cursor --container --emulate-fhs \
    adwaita-icon-theme \
    bash \
    coreutils \
    cursor \
    git \
    -- \
    true

