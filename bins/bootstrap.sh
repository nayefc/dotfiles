#!/bin/bash
platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='osx'
fi

if [[ $platform == 'osx' ]]; then
    brew tap Homebrew/brewdler
    brew install caskroom/cask/brew-cask
    brew brewdle
    # brew install hr
    # brew install pyenv
    # brew install pyenv-virtualenv
    # brew install youtube-dl
    # brew install emacs
    # brew install tmux
elif [[ $platform == 'linux' ]]; then
    # sudo cp bins/hr/hr /usr/local/bin/
    # sudo chmod +x /usr/local/bin/hr
fi
