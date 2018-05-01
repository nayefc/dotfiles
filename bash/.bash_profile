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

    # Homebrew packages path
    export PATH=/usr/local/bin:$PATH

    # Homebrew cask applications folder
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"

    # virtualenvwrapper setup
    VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python2.7
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
    export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND} _virtualenv_auto_activate"

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

    # Completions
    source /usr/local/etc/bash_completion.d/git-completion.bash
    source /usr/local/etc/bash_completion.d/ag.bashcomp.sh
    source /usr/local/etc/bash_completion.d/brew
    source /usr/local/etc/bash_completion.d/tmux
    source /usr/local/etc/bash_completion.d/youtube-dl.bash-completion

    # Second prompt line
    source /usr/local/etc/bash_completion.d/git-prompt.sh

    # Share ssh-agent on my mac
    if [[ ! -S "/tmp/nayef_auth_sock" && -S "$SSH_AUTH_SOCK" ]]; then
	ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
    fi
    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

elif [[ $platform == 'linux' ]]; then
    # Improve ls
    alias ls='ls -lh --color=auto'

    alias lshwnet='lshw -c net -businfo'

    if ! [[ $HOSTNAME =~ "quip" || $HOSTNAME =~ "trade" ]]; then
        # Completions
        source ~/.git-completion.bash
        source ~/.ag.bashcomp.sh
        source ~/.tmux-completion

        # Second prompt line
        source ~/.git-prompt.sh
    fi

    # # Share ssh-agent on remote hosts
    # if [[ ! -S "/tmp/nayef_auth_sock" && -S "$SSH_AUTH_SOCK" ]]; then
    # 	ln -sf $SSH_AUTH_SOCK /tmp/nayef_auth_sock
    # fi
    # export SSH_AUTH_SOCK=/tmp/nayef_auth_sock

fi

# Aliases

# alias to use lower colours in emacs in terminal for solarized compatibility
alias emacs='emacsclient -t -a emacs'

# rm alias
alias rm='rm -i'

# use git diff for regular diffs
alias gdiff='git diff --no-index'

# get current git repo name
alias repo_name='basename `git rev-parse --show-toplevel`'

# print out authors or emails of a git repo
alias authors='git log --all --format='%aN' | sort -u'

# alias grep to egrep and case insensitive
alias grep='grep -E -i --color=always'

alias myps='ps --sort=state -o ruser=WHO -o pid,ppid,state,pcpu -o psr=CPUID -o stime=START -o tty=TTY -o atime=CPUTIME, -o args'
alias bsdps='ps -o ruser=WHO -o pid,ppid,state,pcpu -o psr=CPUID -o stime=START -o tty=TTY -o atime=CPUTIME, -o args'

alias beep='afplay /System/Library/Sounds/Submarine.aiff -v 10'


# Functions

# opens all files with the given regexp
function edit_with() {
    files=`git grep "$1" | awk '{print $1}' | cut -d: -f 1 | xargs -I {} echo -n " " {}`
    emacs $files
}

# open all git conflicted files
function edit_conflicts() {
    files=`git diff --name-only --diff-filter=U`
    emacs $files
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

function clean_files() {
    find ./ -name $1 -delete -print0
}

function clean_dirs() {
    find ./ -name $1 -print0 -exec rm -rf {} \;
}

# kill processes using a tcp port
function kill_port() {
    lsof -i tcp:$1 | awk 'NR!=1 {print $2}' | xargs kill
}

# fasd
eval "$(fasd --init auto)"
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
# alias z='fasd_cd -d'     # cd, same functionality as j in autojump
# alias zz='fasd_cd -d -i' # cd with interactive selection

## fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS='--height 50% --border'
export FZF_DEFAULT_COMMAND='fd --type f'
# Use fd
_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
}
# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
}
# Fuzzy complete using fzf
complete -F _fzf_path_completion -o default -o bashdefault ag
complete -F _fzf_dir_completion -o default -o bashdefault tree

# fasd & fzf change directory - jump using `fasd` if given argument, else filter output of
# `fasd` using `fzf`
_z() {
    [ $# -gt 0 ] && fasd_cd -d "$*" && return
    local dir
    dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}
alias z="_z"
alias fzfprev="fzf --preview 'head -100 {}'"

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


# Setup PS1 git prompt
if ! [[ $HOSTNAME =~ "quip" || $HOSTNAME =~ "trade" ]]; then
    export GIT_PS1_SHOWDIRTYSTATE="1"
    export GIT_PS1_SHOWUNTRACKEDFILES="1"
    export GIT_BRANCH_PROMPT='$(__git_ps1 " (%s)")'
fi


PS1="$CYAN"
if [[ $platform == 'linux' ]]; then
    PS1=$PS1"\h:"
fi

export PS1=$PS1"\j \w$YELLOW$GIT_BRANCH_PROMPT $RED$ $COLOUR_OFF"
