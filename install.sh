#!/usr/bin/env bash

mkdir -p ~/.config/guix
install -m644 ./config/channels.scm ~/.config/guix/
sudo cp ./config/system.scm /etc/config.scm

