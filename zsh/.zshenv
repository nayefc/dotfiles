unamestr=$(uname)
platform='osx'

# Setting for the new UTF-8 terminal support
 LANGUAGE=en_US.UTF-8
 LANG=en_US.UTF-8
 LC_ALL=en_US.UTF-8

# # Homebrew packages path
# export PATH=/usr/local/opt/python@3.8/bin:/usr/local/bin:$PATH

# # Homebrew cask applications folder
# export HOMEBREW_CASK_OPTS="--appdir=/Applications"

export PATH=/opt/homebrew/opt/findutils/libexec/gnubin:$PATH

eval "$(/opt/homebrew/bin/brew shellenv)"

# Improve ls
alias ls='ls -l -G -h'

# test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Second prompt line
source ~/.git-prompt.sh

export SSH_AUTH_SOCK=/Users/nayef/.1password/agent.sock

# Aliases

# alias to use lower colours in emacs in terminal for solarized compatibility
# alias emacs='emacsclient -t -a emacs'

# rm alias
alias rm='rm -i'

# use git diff for regular diffs
alias gdiff='git diff --no-index'

# alias grep to egrep and case insensitive
alias grep='grep -E -i --color=always'

alias ag='ag --ignore src/external --ignore src/unused'

alias agl='ag --pager="less -R"'

alias less="less -Ri"

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
            *.zst)       unzstd -o $(basename $1 .zst) $1 ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# fasd
eval "$(fasd --init auto)"
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection

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
export TERM='xterm-256color'
COLOUR_OFF="\[\e[0m\]"
RED="\[\e[38;5;1m\]"
YELLOW="\[\e[38;5;3m\]"
CYAN="\[\e[38;5;36m\]"

# Setup PS1 git prompt
export GIT_PS1_SHOWDIRTYSTATE="1"
export GIT_PS1_SHOWUNTRACKEDFILES="1"
export GIT_BRANCH_PROMPT='$(__git_ps1 " (%s)")'

PS1="$CYAN"
if [[ $platform == 'linux' ]]; then
    PS1=$PS1"\h:"
fi

export PS1=$PS1"\j \w$YELLOW$GIT_BRANCH_PROMPT $RED$ $COLOUR_OFF"

export TZ_LIST=America/New_York,Etc/UTC,Europe/Zurich,Asia/Amman #,Asia/Singapore


if [ -f "/Users/nayef/.priv.sh" ]; then
   source ~/.priv.sh
fi


. "$HOME/.cargo/env"

# Created by `pipx` on 2025-02-24 12:13:07
# export PATH="$PATH:/Users/nayef/.local/bin"
