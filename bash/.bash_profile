platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='osx'
fi

export EDITOR='/usr/local/bin/emacs'

if [[ $platform == 'osx' ]]; then
    # Setting for the new UTF-8 terminal support
    export LANGUAGE=en_US.UTF-8
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

    if [ -f /etc/profile ]; then
	PATH=""
	source /etc/profile
    fi

    # Homebrew packages path
    export PATH=/usr/local/bin:$PATH

    # Homebrew cask applications folder
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"

    # Hop
    # installation instructions: https://github.com/Cue/hop -- INSTALL IT!
    source /System/Library/Frameworks/Python.framework/Versions/2.7/hop/hop.bash
    hop_json_lua=/System/Library/Frameworks/Python.framework/Versions/2.7/hop/json.lua
    hop_lua=/System/Library/Frameworks/Python.framework/Versions/2.7/hop/hop.lua
    LUA_PATH="$hop_json_lua $hop_lua"
    alias hop-lua-script="LUA_PATH=$LUA_PATH"

    # rvm
    export PATH=$PATH:$HOME/.rvm/bin
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

    # pyenv and pyenv-virtualenv initialisation
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1

    # If Postgress.app is installed, put it in PATH.
    psqlapp="/Applications/Postgres.app/Contents/Versions/9.3/bin/psql"
    if [ -w "$psqlapp" ]; then
	export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.3/bin
    fi

    # Alias youtube-dl if its installed.
    alias youtube="youtube-dl -x --audio-format mp3 --audio-quality 1 -o \"%(title)s.%(ext)s\""

    # Alias hub to git
    eval "$(hub alias -s)"


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


# Aliases

# emacs client alias
alias e='emacsclient -nw'

# alias to use lower colours in emacs in terminal for solarized compatibility
alias emacs='TERM=xterm emacs -nw'

# rm alias
alias rm='rm -i'

# use git diff for regular diffs
alias diff='git diff --no-index'

# get current git repo name
alias repo_name='basename `git rev-parse --show-toplevel`'

# print out authors or emails of a git repo
alias authors='git log --all --format='%aN' | sort -u'

# improve ls
if [[ $platform == 'osx' ]]; then
    alias ls='ls -l -G -h'
fi


# Functions

# opens all files with the given regexp
function edit_with() {
    files=`git grep "$1" | awk '{print $1}' | cut -d: -f 1 | xargs -I {} echo -n " " {}`
    emacs $files
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

# who merged this commit?
function who_merged() {
    commit=`perl -ne 'print if ($seen{$_} .= @ARGV) =~ /10$/' <(git rev-list --ancestry-path $1..HEAD) <(git rev-list --first-parent $1..HEAD) | tail -n 1`
    git show $commit
}

function clean_elpa() {
    find $HOME/dotfiles/emacs/.emacs.d/elpa -regex ".*~.*" -exec rm {} \;
    if [ $? -ne 0 ]; then
        echo "ELPA clean error with $1."
    else
	echo 'ELPA cleaned.'
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

# Copy $1 to clipboard
function copy() {
    echo -n $1 | pbcopy
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


function remote_rsync() {
    # $1: host
    # $1: source path
    # $2: destination path
    rsync --rsync-path="/usr/bin/rsync" $1:$2 $3
}


function run_loop() {
    # $1 number of times to run
    # $2 command to run
    for i in $(seq 1 $1); do
	output=`$2`
	echo $i: $output
    done
}


function merge_master() {
    current_branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

    # $1 the name of the branch to merge master into.
    if [ $# -eq 0 ]; then
	to_merge=$current_branch
	is_head=1
    else
	to_merge=$1
	is_head=0
    fi

    git co master &>/dev/null
    git plr &>/dev/null
    git co $to_merge &>/dev/null

    git merge master --no-edit 2>/dev/null
    if [ $? -ne 0 ]; then
	git reset --merge 2>/dev/null
	echo "Cannot merge due to conflict."
	return
    else
	echo "Master merged into " $to_merge"."
    fi

    hr =

    echo -n "Do you want to push the branch (y/n)? "
    read answer
    if echo "$answer" | grep -iq "^y" ; then
	git ph
    fi

    # If merging another branch (not head), ask to revert to previous branch.
    if [ $is_head -eq 0 ]; then
	hr =
	echo -n "Do you want to return to the orignal branch (y/n)? "
	read answer
	if echo "$answer" | grep -iq "^y" ; then
	    git co $current_branch &>/dev/null
	fi
    fi
}


# Terminal Colours
# See http://misc.flogisoft.com/bash/tip_colors_and_formatting
export CLICOLOR=1
COLOUR_OFF="\[\e[0m\]"
RED="\[\e[38;5;1m\]"
YELLOW="\[\e[38;5;3m\]"
CYAN="\[\e[38;5;36m\]"

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

PS1="$CYAN"
if [[ $platform == 'linux' ]]; then
    PS1=$PS1"\h:"
fi
export PS1=$PS1"\j \w$YELLOW$GIT_BRANCH_PROMPT $RED$ $COLOUR_OFF"

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
#[[ -s "/Users/ncopty/.gvm/bin/gvm-init.sh" ]] && source "/Users/ncopty/.gvm/bin/gvm-init.sh"

# Log every bash command to ~/.logs/
export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.logs/bash-history-$(date "+%Y-%m-%d").log; fi'

# Percolaterc
source ~/dotfiles/bash/.percolaterc

# Go
export GOPATH=$HOME/Documents/go
export PATH=$PATH:$GOPATH/bin

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
