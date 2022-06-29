function __set_ret_code() {
	"${@:2}"
	return "$1"
}

function __prompt_color() {
	# change prompt color according to $?
	[[ "$?" == "0" ]] && echo -ne '\033[36;1m' || echo -ne '\033[31;1m'
}

PS1='\[\033[0;32m\]$(__set_ret_code "$?" printf "%(%H:%M:%S)T") \[\033[36;1m\]<\[\033[31;1m\]\h\[\033[36;1m\]> \[\033[35;1m\]\W\[$(__set_ret_code "$?" __prompt_color)\] \$ \[\033[0m\]'
