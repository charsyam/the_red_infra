#/bin/bash

REPO_ROOT_PATH=$(git rev-parse --show-toplevel)

# 1. install pyenv

PYTHON_VERSION="3.8.6"
VIRTUAL_ENV="the-red-dev"
PYENV_DIR=~/.pyenv

MYSHELL=`echo "$SHELL" | awk -F/ '{print $NF}'`
echo "SHELL: $MYSHELL"
if [ ! -d $PYENV_DIR ]; then
    git clone https://github.com/yyuu/pyenv.git $PYENV_DIR
    git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

    TARGET=~/.bashrc
    if [ "$MYSHELL" = "zsh" ]; then
        TARGET=~/.zshrc
    fi

    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $TARGET
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> $TARGET
    echo 'eval "$(pyenv init --path)"' >> $TARGET
    echo 'eval "$(pyenv virtualenv-init -)"' >> $TARGET

    echo "source $TARGET"
fi

