case "$(uname)" in
Linux)
	alias ls="ls --color=auto"
;;
Darwin)
	alias ls="ls -G"
;;
esac
alias ll="ls -AlhF"
alias la="ls -A"
alias l.="ls -d .[!.]?* ..?* 2>/dev/null || :"
alias ll.="ll -d .[!.]?* ..?* 2>/dev/null || :"
alias l="ll"
alias ..="cd .."
alias grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias fgrep='fgrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias egrep='egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
