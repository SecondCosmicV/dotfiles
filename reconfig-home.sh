#!/usr/bin/env bash

set -xe
rm -f ~/.config/pcmanfm/default/pcmanfm.conf
cd config
guix home reconfigure home.scm
cd -
dconf write /org/gtk/settings/file-chooser/show-hidden true
dconf write /org/gnome/gedit/preferences/editor/tabs-size "uint32 2"
dconf write /org/gnome/gedit/preferences/editor/insert-spaces true
dconf write /org/gnome/gedit/preferences/editor/use-default-font false
dconf write /org/gnome/gedit/preferences/editor/scheme "'solarized-light'"
dconf write /org/gnome/gedit/preferences/ui/side-panel-visible true
dconf write /org/gnome/gedit/state/window/side-panel-active-page "'GeditFileBrowserPanel'"
dconf write /org/gnome/gedit/plugins/filebrowser/filter-mode "@as []"
dconf write /org/gnome/gedit/plugins/active-plugins "['filebrowser', 'sort', 'docinfo']"
dconf write /org/virt-manager/virt-manager/xmleditor-enabled true
cd ~/stuff/secrets
stow -R -v -t ~ .
cd -
for X in normal webapps; do
    install -m644 user.$X.js $(realpath ~/.mozilla/firefox/*.$X)/user.js ||:
done
mkdir -p ~/stuff/channels
guix time-machine --channels=<(guix describe -f channels)
guix shell \
    --container \
    --no-cwd \
    --manifest=$HOME/.local/share/manifests/yt-dlp.scm \
    -- \
    true
guix shell \
    --container \
    --no-cwd \
    --manifest=$HOME/.local/share/manifests/modal.scm \
    -- \
    true
guix shell \
    --container \
    --emulate-fhs \
    --no-cwd \
    --manifest=$HOME/.local/share/manifests/eigenwallet.scm \
    -- \
    true
guix shell \
    --container \
    --emulate-fhs \
    --manifest=$HOME/.local/share/manifests/cursor.scm \
    -- \
    true
mkdir -p ~/.config/discord
guix shell \
    --container \
    --emulate-fhs \
    --no-cwd \
    --network \
    --share=$HOME/.config/discord \
    --manifest=$HOME/.local/share/manifests/discord.scm \
    -- \
    updater_bootstrap \
    --no-zenity \
    $HOME/.config/discord \
    stable \
    "https://updates.discord.com/"
guix shell \
    --container \
    --emulate-fhs \
    --no-cwd \
    --manifest=$HOME/.local/share/manifests/spotify.scm \
    -- \
    true
guix describe -f channels > ~/.config/guix/channels.pinned.scm

