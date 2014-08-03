platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='osx'
fi

if [[ $platform == 'osx' ]]; then

    # Setting for the new UTF-8 terminal support
    export LANGUAGE=en_US.UTF-8
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

    # Homebrew
    source `brew --repository`/Library/Contributions/brew_bash_completion.sh
    export PATH=/usr/local/bin:$PATH

    # Hop
    # installation instructions: https://github.com/Cue/hop -- INSTALL IT!
    source /System/Library/Frameworks/Python.framework/Versions/2.7/hop/hop.bash
    alias hop-lua-script="LUA_PATH=/System/Library/Frameworks/Python.framework/Versions/2.7/hop/json.lua /System/Library/Frameworks/Python.framework/Versions/2.7/hop/hop.lua"

    # rvm
    PATH=$PATH:$HOME/.rvm/bin
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

    # pyenv and pyenv-virtualenv initialisation
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

elif [[ $platform == 'linux' ]]; then

    # SSH agent fowarding
    export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock

    # Virtualenv
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python2.7
    export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv-2.7
    source /usr/local/bin/virtualenvwrapper.sh

    # Hop
    # installation instructions: https://github.com/Cue/hop -- INSTALL IT!
    source /usr/local/hop/hop.bash
    alias hop-lua-script="LUA_PATH=/usr/local/hop/json.lua /usr/local/hop/hop.lua"
fi

# emacs client alias
alias e='emacsclient -nw'

# rm alias
alias rm='rm -i'

# use git diff for regular diffs
alias diff='git diff --no-index'

# get current git repo name
alias repo_name='basename `git rev-parse --show-toplevel`'

# print out authors or emails of a git repo
alias authors='git log --all --format='%aN' | sort -u'
alias emails='git log --all --format='%ae' | sort -u'

alias clean_fly='find . -name \flycheck* -type f -delete'

# alias and functions
if [[ $platform == 'osx' ]]; then
    alias ls='ls -l -G -h'
elif [[ $platform == 'linux' ]]; then
    alias ls='ls -l --color -h'
    get_hosts () {
	host $1 | awk '{ print $4}' | xargs -I {} grep '{}\b' /etc/hosts
    }
    alias get_hosts=get_hosts
    alias mgmydb="mysql -h mysql-maestro.mgmt.adnxs.net -u ncopty -p --prompt 'maestroMGMT!!!> '"
    alias devmydb="mysql -u ncopty -p -h mysql-maestro.dev.adnxs.net --prompt 'maestroDEV read-only> '"
    alias mgtendb="psql -h jazzhands-db.appnexus.net -U app_tendril_api jazzhands"
    alias devtendb="psql -h 02.kovert-sand.nym2.appnexus.net -U tendril_dev jazzhands"

    # scurl tool
    source ~/dotfiles/bins/scurl
fi

# opens all files with the given regexp
function edit_with() {
    files=`git grep $1 | awk '{print $1}' | cut -d: -f 1 | xargs -I {} echo -n " " {}`
    if ps ax | grep -v grep | grep 'emacs --daemon' > /dev/null
    then
	e $files
    else
	emacs $files
    fi
}

function clean_elpa() {
    find $HOME/dotfiles/emacs/.emacs.d/elpa -regex ".*~.*" -exec rm {} \;
    if [ $? -ne 0 ]; then
        echo "ELPA clean error with $1."
    else
	echo 'ELPA cleaned.'
    fi
}

# open all git conflicted files
function edit_conflicts() {
    files=`git diff --name-only --diff-filter=U`
    if ps ax | grep -v grep | grep 'emacs --daemon' > /dev/null
    then
	e $files
    else
	emacs $files
    fi
}

# swaps two files
function swap() {
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

# count for $1 mins
function count() {
    min=$(($1-1))
    while [ $min -ge 0 ]; do
	sec=59
	while [ $sec -ge 0 ]; do
	    printf '00:%02d:%02d\033[0K\r' $min $sec
	    sleep 1
	    sec=$((sec-1))
	done
	min=$((min-1))
    done
    sleep 1
}

# Extracting files
function extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xvf $1     ;;
            *.tbz2)      tar xvjf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Terminal Colours
export CLICOLOR=1
BLACK="\[\033[0;30m\]"
DARK_GRAY="\[\033[1;30m\]"
LIGHT_GRAY="\[\033[0;37m\]"
WHITE="\[\033[0;37m\]"
RED="\[\033[0;31m\]"
RED_BOLD="\[\033[1;31m\]"
YELLOW="\[\033[0;33m\]"
YELLOW_BOLD="\[\033[1;33m\]"
GREEN="\[\033[0;32m\]"
GREEN_BOLD="\[\033[1;32m\]"
BLUE="\[\033[0;34m\]"
BLUE_BOLD="\[\033[1;34m\]"
CYAN="\[\033[0;36m\]"
CYAN_BOLD="\[\033[1;36m\]"
PURPLE="\[\033[0;35m\]"
PURPLE_BOLD="\[\033[1;35m\]"
BROWN="\[\033[0;33m\]"

# Terminal colours
export CLICOLOR=1
if [[ $platform == 'osx' ]]; then
    export TERM='xterm-256color'
elif [[ $platform == 'linux' ]]; then
    if [ -e /usr/share/terminfo/x/xterm-256color ]; then
	export TERM='xterm-256color'
    else
	export TERM='xterm-color'
    fi
    export LS_COLORS='di=1;31:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35'
fi

# Second prompt line
source ~/.git-completion.sh

export GIT_PS1_SHOWDIRTYSTATE="1"
export GIT_PS1_SHOWUNTRACKEDFILES="1"
export GIT_BRANCH_PROMPT='$(__git_ps1 " (%s)")'

PS1="\[\033[0;36m\]"
if [[ $platform == 'linux' ]]; then
    PS1=$PS1"\h:"
fi
export PS1=$PS1"\j \w\[\033[1;33m\]$GIT_BRANCH_PROMPT \[\033[0;31m\]$ \[\e[0m\]"

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/Users/ncopty/.gvm/bin/gvm-init.sh" ]] && source "/Users/ncopty/.gvm/bin/gvm-init.sh"
