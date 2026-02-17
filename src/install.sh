#!/bin/sh
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install --assume-yes --no-install-recommends \
  software-properties-common \
  zsh \
  ca-certificates \
  curl \
  git \
  build-essential \
  clangd \
  python3 \
  python3-venv \
  shellcheck \
  npm

chsh -s /usr/bin/zsh

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
export PATH=/root/.cargo/bin:$PATH

curl --output helix.deb --location https://github.com/helix-editor/helix/releases/download/25.07.1/helix_25.7.1-1_amd64.deb
apt-get install -y ./helix.deb
rm helix.deb

curl -LsSf https://astral.sh/uv/install.sh | sh
curl -sSL https://install.python-poetry.org | python3 -

export VIRTUAL_ENV=/venv
export POETRY_NO_INTERACTION=1
export POETRY_VIRTUALENVS_CREATE=false
export PATH=$VIRTUAL_ENV/bin:/root/.local/bin:$PATH

python3 -m venv $VIRTUAL_ENV

uv pip install \
  isort \
  ruff \
  python-lsp-server \
  python-lsp-black \
  pylsp-mypy \
  ty

uv tool install commitizen

npm install --global \
  vscode-langservers-extracted \
  bash-language-server \
  dockerfile-language-server-nodejs \
  @microsoft/compose-language-service

cargo install --git https://github.com/latex-lsp/texlab --locked --tag v5.24.0

mkdir --parents /root/.config/helix /root/.config/dprint
cp config.toml /root/.config/helix/config.toml
cp languages.toml /root/.config/helix/languages.toml
cp dprint.json /root/.config/dprint/dprint.json

git config --global credential.helper store

# default shell
cat << 'EOF' > /etc/profile.d/hx-and-friends-shell.sh
export SHELL=/usr/bin/zsh
EOF
