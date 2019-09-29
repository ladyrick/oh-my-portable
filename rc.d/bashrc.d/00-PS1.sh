function __prompt_color() {
	# change prompt color according to $?
	[[ "$?" == "0" ]] && echo -e '\033[36;1m' || echo -e '\033[31;1m'
}

export PS1='\[\033[36;1m\]<\[\033[31;1m\]\h\[\033[36;1m\]> \[\033[35;1m\]\W$(__prompt_color) \$ \[\033[00m\]'
