#/bin/bash

REPO_ROOT_PATH=$(git rev-parse --show-toplevel)

# 1. install pyenv

PYTHON_VERSION="3.8.6"
VIRTUAL_ENV="the-red-dev"
PYENV_DIR=~/.pyenv

install_python_version=$(pyenv versions | grep $PYTHON_VERSION)
if [ -z "$install_python_version" ]; then
    echo "   1-1) INSTALLING PYTHON $PYTHON_VERSION"
    pyenv install $PYTHON_VERSION
    pyenv shell $PYTHON_VERSION
    pip install --upgrade pip
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

pyenv local $VIRTUAL_ENV
pyenv rehash
