#!/bin/bash
platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='osx'
fi

if [[ $platform == 'osx' ]]; then
    brew install hr
    brew install pyenv
    brew install pyenv-virtualenv
elif [[ $platform == 'linux' ]]; then
    sudo cp bins/hr/hr /usr/local/bin/
    sudo chmod +x /usr/local/bin/hr
fi

# Maybe symlink this
chmod a+x bins/youtube-dl/youtube-dl
cp bins/youtube-dl/youtube-dl /usr/local/bin/youtube-dl
