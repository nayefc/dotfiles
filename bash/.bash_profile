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

    # autojump
    [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

    # rvm
    export PATH=$PATH:$HOME/.rvm/bin
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

    # virtualenvwrapper setup
    source /usr/local/bin/virtualenvwrapper.sh

    function _virtualenv_auto_activate() {
	if [ -e ".venv" ]; then
            if [ -f ".venv" ]; then
		_VENV_PATH=$WORKON_HOME/$(cat .venv)
		_VENV_WRAPPER_ACTIVATE=true
            else
		return
            fi

            # Check to see if already activated to avoid redundant activating
            if [ "$VIRTUAL_ENV" != $_VENV_PATH ]; then
		if $_VENV_WRAPPER_ACTIVATE; then
                    _VENV_NAME=$(basename $_VENV_PATH)
                    workon $_VENV_NAME
		fi
                echo Activated virtualenv \"$_VENV_NAME\".
            fi
	fi
    }
    export PROMPT_COMMAND=_virtualenv_auto_activate

    # If Postgress.app is installed, put it in PATH.
    psqlapp="/Applications/Postgres.app/Contents/Versions/9.3/bin/psql"
    if [ -w "$psqlapp" ]; then
	export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.3/bin
    fi

    # Alias youtube-dl if its installed.
    alias youtube="youtube-dl -x --audio-format mp3 --audio-quality 1 -o \"%(title)s.%(ext)s\""

    # Improve ls
    alias ls='ls -l -G -h'

    test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

elif [[ $platform == 'linux' ]]; then
    # Improve ls
    alias ls='ls -lh --color=auto'
fi


# Aliases

# emacs client alias
alias e='emacsclient -nw'

# alias to use lower colours in emacs in terminal for solarized compatibility
alias emacs='TERM=xterm emacs -nw'

# rm alias
alias rm='rm -i'

# use git diff for regular diffs
alias gdiff='git diff --no-index'

# get current git repo name
alias repo_name='basename `git rev-parse --show-toplevel`'

# print out authors or emails of a git repo
alias authors='git log --all --format='%aN' | sort -u'


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


# Terminal colours
# See http://misc.flogisoft.com/bash/tip_colors_and_formatting
export CLICOLOR=1
if [[ $platform == 'osx' ]]; then
    export TERM='xterm-256color'
    COLOUR_OFF="\[\e[0m\]"
    RED="\[\e[38;5;1m\]"
    YELLOW="\[\e[38;5;3m\]"
    CYAN="\[\e[38;5;36m\]"
elif [[ $platform == 'linux' ]]; then
    if [  -e /lib/terminfo/x/xterm-256color ]; then
	export TERM='xterm-256color'
    else
	export TERM='xterm-color'
    fi
    export LS_COLORS='ln=35:ex=31'
    COLOUR_OFF="\[\e[0m\]"
    RED="\[\e[38;5;1m\]"
    YELLOW="\[\e[38;5;3m\]"
    CYAN="\[\e[38;5;36m\]"
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

# HRT
source ~/.hrtrc
