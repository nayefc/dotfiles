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
    source /usr/local/bin/virtualenvwrapper.sh
    export PATH=/usr/local/bin:$PATH
elif [[ $platform == 'linux' ]]; then
    export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
    PATH=$PATH:$HOME/tasker-cli/
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python2.7
    export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv-2.7
    source /usr/local/bin/virtualenvwrapper.sh
fi

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

# rm alias
alias rm='rm -i'

# use git diff for regular diffs
alias diff='git diff --no-index'

# print out authors or emails of a git repo
alias authors='git log --all --format='%aN' | sort -u'
alias emails='git log --all --format='%ae' | sort -u'

# alias and functions
if [[ $platform == 'osx' ]]; then
    alias ls='ls -l -G -h'
elif [[ $platform == 'linux' ]]; then
    alias ls='ls -l --color -h'
    get_hosts () {
	host $1 | awk '{ print $4}' | xargs -I {} grep {} /etc/hosts
    }
    alias get_hosts=get_hosts
    alias mgmaedb="mysql -h mysql-maestro.mgmt.adnxs.net -u ncopty -p --prompt 'maestroMGMT!!!> '"
    alias devmaedb="mysql -u ncopty -p -h mysql-maestro.dev.adnxs.net maestrodev --prompt 'maestroDEV read-only> '"
fi

edit_with() {
    files=`grep -r $1 ./ | awk '{print $1}' | cut -d: -f 1 | xargs -I {} echo -n " " {}`
    emacs $files
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

if [[ $platform == 'osx' ]]; then
    export PS1="\[\033[0;36m\]\w\[\033[1;33m\]$GIT_BRANCH_PROMPT \[\033[0;31m\]$ \[\e[0m\]"
elif [[ $platform == 'linux' ]]; then
    export PS1="\[\033[0;36m\]\h \w\[\033[1;33m\]$GIT_BRANCH_PROMPT \[\033[0;31m\]$ \[\e[0m\]"
fi
