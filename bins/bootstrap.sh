#!/bin/bash
platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='osx'
fi

if [[ $platform == 'osx' ]]; then
    brew bundle
    echo -e "pylint\ipdb\njedi\n#jediepcserver" > ~/.pyenv/default-packages
# elif [[ $platform == 'linux' ]]; then
    # sudo cp bins/hr/hr /usr/local/bin/
    # sudo chmod +x /usr/local/bin/hr
fi
