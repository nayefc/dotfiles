platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='osx'
fi

# rvm
PATH=$PATH:$HOME/.rvm/bin
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

if [[ $platform == 'osx' ]]; then
    # pythonbrew
    [[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc
fi

# installation instructions: https://github.com/Cue/hop -- INSTALL IT!

# Initialize the 'hop' script and
# define an entry point for the lua script version of hop
if [[ $platform == 'osx' ]]; then
    source /System/Library/Frameworks/Python.framework/Versions/2.7/hop/hop.bash
    alias hop-lua-script="LUA_PATH=/System/Library/Frameworks/Python.framework/Versions/2.7/hop/json.lua /System/Library/Frameworks/Python.framework/Versions/2.7/hop/hop.lua"
elif [[ $platform == 'linux' ]]; then
    source /usr/local/hop/hop.bash
    alias hop-lua-script="LUA_PATH=/usr/local/hop/json.lua /usr/local/hop/hop.lua"
fi
