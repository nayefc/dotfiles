#!/bin/bash
platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='osx'
fi

git submodule update --init --recursive

# install stow
if [[ $platform == 'osx' ]]; then
    brew install stow
    brew install emacs
elif [[ $platform == 'linux' ]]; then
    sudo yum install stow
    sudo yum install emacs
fi

ruby bootstrap

# replaced with ruby script
# # stow packages
# stow bash
# stow tmux
# stow git
# stow emacs

# if [[ $platform == 'linux' ]]; then
#     stow ssh
# fi

# install bins
./bins/bootstrap.sh

# packages used by emacs
sudo pip install pylint
