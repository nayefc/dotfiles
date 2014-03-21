#!/bin/bash
platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='osx'
fi

gem install rubocop

if [[ $platform == 'osx' ]]; then
    brew install hr
elif [[ $platform == 'linux' ]]; then
    sudo cp bins/hr/hr /usr/local/bin/
    sudo chmod +x /usr/local/bin/hr
fi

if [[ $platform == 'osx' ]]; then
    sudo cp bins/chrome-cli /usr/local/bin/chrome-cli
    sudo chmod +x /usr/local/bin/chrome-cli
elif [[ $platform == 'linux' ]]; then
    sudo cp bins/chrome-cli-remote /usr/local/bin/chrome-cli
    sudo chmod +x /usr/local/bin/chrome-cli
fi
