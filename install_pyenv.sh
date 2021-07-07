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
    echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
fi

. ~/.bashrc

install_python_version=$(pyenv versions | grep $PYTHON_VERSION)
if [ -z "$install_python_version" ]; then
    echo "   1-1) INSTALLING PYTHON $PYTHON_VERSION"
    pyenv install $PYTHON_VERSION
    pyenv shell $PYTHON_VERSION
    easy_install -U setuptools
    pip install virtualenv
else
    echo "   1-1) INSTALLING PYTHON $PYTHON_VERSION (DONE)"
fi

installenv=$(pyenv versions | grep $VIRTUAL_ENV)
if [ -z "$installenv" ]; then
    echo "   1-2) INSTALLING VIRTUALENV $VIRTUAL_ENV"
    pyenv virtualenv $PYTHON_VERSION $VIRTUAL_ENV;
else
    echo "   1-2) INSTALLING VIRTUALENV $VIRTUAL_ENV (DONE)"
fi

echo "   2) use $VIRTUAL_ENV"
pyenv local $PYTHON_VERSION $VIRTUAL_ENV
pyenv rehash

. ~/.bashrc

pip install -r ./requirements.txt
