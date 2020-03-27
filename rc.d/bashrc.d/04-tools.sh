function keygen() {
	declare -i keylen
	if [[ -z "$1" ]]; then
		keylen=32
	else
		keylen="$1" || {
			echo "need an integer."
			return 1
		}
		((keylen <= 0)) && return 0
	fi
	key=$(openssl rand -hex $(((keylen + 1) / 2)))
	echo ${key:0:${keylen}}
}

function __echo_color_8() {
	if ((30 <= $1 && $1 <= 37)); then
		local color_code="$1"
		shift
	fi
	while [[ -n "$1" ]]; do
		if [[ "$1" == "-b" ]]; then
			local decoration="1"
			shift
		elif [[ "$1" == "-u" ]]; then
			local decoration="4"
			shift
		elif [[ "$1" == "-ub" || "$1" == "-bu" ]]; then
			local decoration="1;4"
			shift
		else
			break
		fi
	done
	if [[ -t 1 ]]; then
		[[ -n "$decoration" ]] && echo -ne "\e[${decoration}m"
		[[ -n "$color_code" ]] && echo -ne "\e[${color_code}m"
		echo "$@"
		echo -ne "\e[0m"
	else
		echo "$@"
	fi
}

alias black="__echo_color_8 30"
alias red="__echo_color_8 31"
alias green="__echo_color_8 32"
alias yellow="__echo_color_8 33"
alias blue="__echo_color_8 34"
alias magenta="__echo_color_8 35"
alias cyan="__echo_color_8 36"
alias white="__echo_color_8 37"

function c256() {
	if [[ "$1" == 0 ]] || ((1 <= $1 && $1 <= 256)); then
		local color_code="$1"
		shift
	fi
	while [[ -n "$1" ]]; do
		if [[ "$1" == "-b" ]]; then
			local decoration="1"
			shift
		elif [[ "$1" == "-u" ]]; then
			local decoration="4"
			shift
		elif [[ "$1" == "-ub" || "$1" == "-bu" ]]; then
			local decoration="1;4"
			shift
		else
			break
		fi
	done
	if [[ -t 1 ]]; then
		[[ -n "$decoration" ]] && echo -ne "\e[${decoration}m"
		[[ -n "$color_code" ]] && echo -ne "\e[38;5;${color_code}m"
		echo "$@"
		echo -ne "\e[0m"
	else
		echo "$@"
	fi
}

function hostip() {
	host $(hostname) | awk '/has address/{print $NF}'
}
