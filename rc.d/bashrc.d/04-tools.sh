function keygen() {
	local keylen=32
	local level=1
	for arg in "$@"; do
		if [[ "$arg" =~ ^[1-9][0-9]*$ ]]; then
			keylen="$arg"
		elif [[ "$arg" == "-w" ]]; then
			if [[ "$level" == 1 || "$level" == 0 ]]; then
				level=0
			else
				echo "-w and -s cannot be set at the same time"
				return 1
			fi
		elif [[ "$arg" == "-s" ]]; then
			if [[ "$level" == 1 || "$level" == 2 ]]; then
				level=2
			else
				echo "-w and -s cannot be set at the same time"
				return 1
			fi
		else
			echo "invalid parameter: \"$arg\""
			return 1
		fi
	done
	unset arg
	if [[ "$level" == 0 ]]; then
		local choices='abcdef0123456789'
	elif [[ "$level" == 1 ]]; then
		local choices='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
	else
		local choices='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"'"'"'`~!@#$%^&*()_+-=[{]}\|;:,<.>/?'
	fi
	python -c "import random as r,time;c=r'''$choices''';r.seed(time.time());print(''.join(r.choice(c) for _ in range($keylen)))"
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
	[[ ! "$1" =~ ^[0-9]+$ ]] && echo "need a color code (0-256)" && return 1
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
	hostname -I | cut -d ' ' -f 1
}

if [[ -d "$KCONFIG_DIR" ]]; then
	function kconfig() {
		if [[ -f "$KCONFIG_DIR/$1" ]]; then
			export KUBECONFIG="$KCONFIG_DIR/$1"
		fi
	}
	__kconfig_comp() {
		if [[ ${#COMP_WORDS[@]} == 2 ]]; then
			COMPREPLY=($(compgen -W "$(ls "$KCONFIG_DIR")" "${COMP_WORDS[1]}"))
		else
			COMPREPLY=()
		fi
	}
	complete -F __kconfig_comp kconfig
fi
