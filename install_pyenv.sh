#/bin/bash

REPO_ROOT_PATH=$(git rev-parse --show-toplevel)

# 1. install pyenv

PYTHON_VERSION="3.8.6"
VIRTUAL_ENV="the-red-dev"
PYENV_DIR=~/.pyenv

if [ ! -d $PYENV_DIR ]; then
    git clone https://github.com/yyuu/pyenv.git $PYENV_DIR
    git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
fi
