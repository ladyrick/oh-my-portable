if [[ $- == *i* ]]; then
	bind '"\e[A": history-search-backward'
	bind '"\e[B": history-search-forward'
	bind '"\e[C": forward-char'
	bind '"\e[D": backward-char'
	bind '"\e[Z": menu-complete-backward'
fi
