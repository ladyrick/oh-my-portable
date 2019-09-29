[[ "$(uname)" == "Darwin" ]] && alias ls="ls -G" || alias ls="ls --color=auto"
alias ll="ls -alhF"
alias la="ls -a"
alias l="ll"
alias ..="cd .."
alias grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias fgrep='fgrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias egrep='egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
