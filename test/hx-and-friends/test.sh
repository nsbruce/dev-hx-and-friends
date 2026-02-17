#!/bin/sh
set -e

# Basic smoke tests for hx-and-friends feature

command -v zsh
command -v python3.14
command -v rustc || command -v cargo
command -v hx || command -v helix
command -v uv
command -v poetry
command -v zellij

[ -f /root/.config/helix/config.toml ]
[ -f /root/.config/helix/languages.toml ]
[ -f /root/.config/dprint/dprint.json ]
