# platform='unknown'
# unamestr=$(uname)
# if [[ "$unamestr" == 'Darwin' ]]; then
#     platform='osx'
# fi
#     if [[ $platform == 'osx' ]]; then
#         # Setting for the new UTF-8 terminal support
#         export LANGUAGE=en_US.UTF-8
#         export LANG=en_US.UTF-8
#         export LC_ALL=en_US.UTF-8

#         # Hop
#         source /System/Library/Frameworks/Python.framework/Versions/2.7/hop/hop.bash
#         alias hop-lua-script="
# LUA_PATH=/System/Library/Frameworks/Python.framework/Versions/2.7/hop/json.lua /System/Library/Frameworks/Python.framework/Versions/2.7/hop/ho

#     # pyenv and pyenv-virtualenv initialisation
#     eval "$(pyenv init -)"
#     eval "$(pyenv virtualenv-init -)"

#     alias ls='ls -l -G -h'

# fi

# # Terminal colours
# export CLICOLOR=1
# if [[ $platform == 'osx' ]]; then
#     export TERM='xterm-256color'
# fi

# # Second prompt line
# source ~/.git-completion.sh
# export GIT_PS1_SHOWDIRTYSTATE="1"
# export GIT_PS1_SHOWUNTRACKEDFILES="1"
# export GIT_BRANCH_PROMPT='$(__git_ps1 " (%s)")'
# PS1="\[\033[0;36m\]"
# export PS1=$PS1"\j \w\[\033[1;33m\]$GIT_BRANCH_PROMPT \[\033[0;31m\]$ \[\e[0m\]"
