#!/usr/bin/env bash

set -xe
mkdir -p ~/.config/guix
install -m644 ./config/channels.scm ~/.config/guix/

