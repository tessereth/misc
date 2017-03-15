HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
HISTSIZE=5000
HISTFILESIZE=10000

# bash completion

if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

# ruby

export PATH="$HOME/.rbenv/shims:$PATH"
eval "$(rbenv init -)"

# git

. /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
PROMPT_COMMAND='__git_ps1 "\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]" "\$ "'
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWCOLORHINTS=1
alias gitclean='git fetch --prune; git branch --merged | grep -Ev "(\*|master|develop|staging)" | xargs -n 1 git branch -d'

# go

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:"$PATH"

# misc

alias rgrep="ggrep --color=auto -r -n"
alias rbgrep="ggrep --color=auto -r -n --include='*.rb' --include='*.haml' --include='*.erb' --include='*css' --include='*.js' --exclude-dir=node_modules"
alias dgrep="ggrep --color=auto -r -n --exclude-dir=vendor --include='*.go' --include='*.jsx' --include='*.js'"
export EDITOR=nano
export CLICOLOR=1
