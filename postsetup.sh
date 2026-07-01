#!/usr/bin/env bash

set -xe
dconf write /org/gtk/settings/file-chooser/show-hidden true
dconf write /org/virt-manager/virt-manager/xmleditor-enabled true
cd ~/stuff/secrets
stow -R -v -t ~ .
mkdir -p ~/stuff/roots
rm -f ~/stuff/roots/yt-dlp
guix shell \
    -r ~/stuff/roots/yt-dlp \
    --container \
    --no-cwd \
    coreutils \
    nss-certs \
    openssl \
    python-yt-dlp \
    -- \
    true
rm -f ~/stuff/roots/eigenwallet
guix shell \
    -r ~/stuff/roots/eigenwallet \
    --container \
    --emulate-fhs \
    --no-cwd \
    coreutils \
    eigenwallet \
    -- \
    true
rm -f ~/stuff/roots/cursor
guix shell \
    -r ~/stuff/roots/cursor \
    --container \
    --emulate-fhs \
    adwaita-icon-theme \
    coreutils \
    cursor \
    git \
    xdg-open-hack \
    -- \
    true
rm -f ~/stuff/roots/discord
mkdir -p ~/.config/discord
guix shell \
    -r ~/stuff/roots/discord \
    --container \
    --emulate-fhs \
    --no-cwd \
    --network \
    --share=$HOME/.config/discord \
    adwaita-icon-theme \
    discord \
    -- \
    updater_bootstrap \
    --no-zenity \
    $HOME/.config/discord \
    stable \
    "https://updates.discord.com/"
rm -f ~/stuff/roots/spotify
guix shell \
    -r ~/stuff/roots/spotify \
    --container \
    --emulate-fhs \
    --no-cwd \
    adwaita-icon-theme \
    coreutils \
    font-dejavu \
    font-google-noto \
    font-google-noto-emoji \
    font-google-noto-sans-cjk \
    font-google-noto-sans-cjk \
    font-google-noto-sans-hebrew \
    libayatana-appindicator \
    libayatana-ido \
    libayatana-indicator \
    libdbusmenu \
    spotify \
    -- \
    true

