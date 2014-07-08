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
    sudo cp bins/chrome-cli /usr/local/bin/chrome-cli
    sudo chmod +x /usr/local/bin/chrome-cli
elif [[ $platform == 'linux' ]]; then
    sudo cp bins/hr/hr /usr/local/bin/
    sudo chmod +x /usr/local/bin/hr
    sudo cp bins/chrome-cli-remote /usr/local/bin/chrome-cli
    sudo chmod +x /usr/local/bin/chrome-cli
fi

chmod a+x bins/youtube-dl/youtube-dl
cp bins/youtube-dl/youtube-dl /usr/local/bin/youtube-dl
