platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='osx'
fi

if [[ $platform == 'osx' ]]; then
    eval "$(pyenv init -)"
    export PATH="/Users/ncopty/.pyenv/shims:${PATH}"
    export PYENV_SHELL=bash
    source '/usr/local/Cellar/pyenv/20140211/libexec/../completions/pyenv.bash'
    pyenv rehash 2>/dev/null
    pyenv() {
	local command
	command="$1"
	if [ "$#" -gt 0 ]; then
	    shift
	fi

	case "$command" in
	    rehash|shell)
		eval "`pyenv "sh-$command" "$@"`";;
	    *)
		command pyenv "$command" "$@";;
	esac
    }
fi

# rvm
PATH=$PATH:$HOME/.rvm/bin
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
