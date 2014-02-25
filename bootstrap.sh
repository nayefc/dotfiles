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
elif [[ $platform == 'linux' ]]; then
    sudo yum install stow
fi

# stow packages
stow bash
stow tmux
stow git
stow emacs

if [[ $platform == 'linux' ]]; then
    stow ssh
fi

# install bins
./bins/bootstrap.sh

# packages used by emacs
sudo pip install pylint

# TODO: separate bootstrap and pass in argument of what to boostrap.
# For example, pass in 'all' to set up a machine from scratch, or 'bin' to boostrap bins.
