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

    export BASH_SILENCE_DEPRECATION_WARNING=1

    # Homebrew packages path
    export PATH=/usr/local/bin:$PATH

    # Homebrew cask applications folder
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"

    # Alias youtube-dl if its installed.
    # alias youtube="youtube-dl -x --audio-format mp3 --audio-quality 1 -o \"%(title)s.%(ext)s\""

    # Improve ls
    alias ls='ls -l -G -h'

    test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

    # llvm
    export PATH="/usr/local/opt/llvm/bin:$PATH"
    export LDFLAGS="-L/usr/local/opt/llvm/lib"
    export CPPFLAGS="-I/usr/local/opt/llvm/include"

    # Completions
    source /usr/local/etc/bash_completion.d/git-completion.bash
    source /usr/local/etc/bash_completion.d/ag.bashcomp.sh
    source /usr/local/etc/bash_completion.d/brew
    source /usr/local/etc/bash_completion.d/tmux

    export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
    [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

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

    # Completions
    source ~/.git-completion.bash
    source ~/.ag.bashcomp.sh
    source ~/.tmux-completion

    # Second prompt line
    source ~/.git-prompt.sh
fi

# Google Cloud
source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc
source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc

source ~/.tokens

# Aliases

# alias to use lower colours in emacs in terminal for solarized compatibility
# alias emacs='emacsclient -t -a emacs'

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

alias agl='ag --pager="less -R"'

alias less="less -Ri"


# Functions

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

# Compress files
function compress() {
    tar -czvf $1 $2
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

function delete_files() {
    find ./ -name $1 -delete -print0
}

function remove_dirs() {
    find ./ -name $1 -print0 -exec rm -rf {} \;
}

# kill processes using a tcp port
function kill_port() {
    lsof -i tcp:$1 | awk 'NR!=1 {print $2}' | xargs kill
}

function git_replace() {
    git grep -l $1 | xargs sed -i '' -e 's/$1/$2/g'
}

function git_replace_linux() {
    git grep -l $1 | xargs sed -i 's/$1/$2/g'
}

export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault-pass

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

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
export GIT_PS1_SHOWDIRTYSTATE="1"
export GIT_PS1_SHOWUNTRACKEDFILES="1"
export GIT_BRANCH_PROMPT='$(__git_ps1 " (%s)")'

PS1="$CYAN"
if [[ $platform == 'linux' ]]; then
    PS1=$PS1"\h:"
fi

export PS1=$PS1"\j \w$YELLOW$GIT_BRANCH_PROMPT $RED$ $COLOUR_OFF"

export PATH="$HOME/.poetry/bin:$PATH"

#
# Kubernetes
#
# Set the default kube context if present
DEFAULT_KUBE_CONTEXTS="$HOME/.kube/config"
if test -f "${DEFAULT_KUBE_CONTEXTS}"
then
  export KUBECONFIG="$DEFAULT_KUBE_CONTEXTS"
fi

# Additional contexts should be in ~/.kube/custom-contexts/
CUSTOM_KUBE_CONTEXTS="$HOME/.kube/custom-contexts"
mkdir -p "${CUSTOM_KUBE_CONTEXTS}"

OIFS="$IFS"
IFS=$'\n'
for contextFile in `find "${CUSTOM_KUBE_CONTEXTS}" -type f -name "*.yml"`
do
    export KUBECONFIG="$contextFile:$KUBECONFIG"
done
IFS="$OIFS"
