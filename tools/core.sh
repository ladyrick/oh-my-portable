############################################### core ###############################################

shopt -s expand_aliases

function ssh() {
	declare -a ssh_args
	local host host_set cmd cmd_set
	while [[ $# > 0 ]]; do
		case "$1" in
		-[bcDEeFIiJLlmOopQRSWw])
			ssh_args+=("$1" "$2")
			shift 2
			;;
		-?*)
			ssh_args+=("$1")
			shift
			;;
		*)
			if [[ -z "${host_set}" ]]; then
				host="$1"
				host_set=1
				shift
			else
				cmd="${*}"
				cmd_set=1
				break
			fi
			;;
		esac
	done
	if [[ -z "${host_set}" ]]; then
		/usr/bin/env ssh "${ssh_args[@]}"
	elif [[ -z "${cmd_set}" ]]; then
		local __OH_MY_PORTABLE_REMOTE_PROFILE_STRING=${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING:-$(cat $OH_MY_PORTABLE/dist/remote_profile.sh)}
		/usr/bin/env ssh -tq "${ssh_args[@]}" "$host" "bash --rcfile <(
		echo 'export __OH_MY_PORTABLE_REMOTE_PROFILE_STRING='\\''${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING//\'/\'\\\'\'\\\'\\\'\'\'\\\'\'}'\\'
		cat /etc/profile
		{ cat ~/.bash_profile || cat ~/.bash_login || cat ~/.profile; } 2>/dev/null
		echo 'eval \"\${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING}\"'
		)"
	else
		local __OH_MY_PORTABLE_REMOTE_PROFILE_STRING=${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING:-$(cat $OH_MY_PORTABLE/dist/remote_profile.sh)}
		/usr/bin/env ssh -tq "${ssh_args[@]}" "$host" "bash -c '
		export __OH_MY_PORTABLE_REMOTE_PROFILE_STRING='\\''${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING//\'/\'\\\'\'\\\'\\\'\'\'\\\'\'}'\\''
		eval \"\${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING}\"
		${cmd//\'/\'\\\'\'}
		'"
	fi
}

if [[ "$OH_MY_PORTABLE" ]]; then
	function refresh_oh_my_portable() {
		source $OH_MY_PORTABLE/oh-my-portable.sh && echo -e '\e[32mFinished\e[0m' || echo -e '\e[31mError\e[0m'
	}
	function update_oh_my_portable() {
		echo "[omp] update $OH_MY_PORTABLE/rc.d.private"
		if [[ -d "$OH_MY_PORTABLE/rc.d.private" ]]; then
			if [[ -d "$OH_MY_PORTABLE/rc.d.private/.git" ]]; then
				cd "$OH_MY_PORTABLE/rc.d.private"
				echo '[omp] git pull rc.d.private'
				git pull
			else
				echo '[omp] rc.d.private is not a git repo. skip update'
			fi
		else
			echo '[omp] rc.d.private not found. skip update'
		fi

		echo "[omp] update $OH_MY_PORTABLE"
		cd "$OH_MY_PORTABLE"
		git pull

		echo "[omp] refresh $OH_MY_PORTABLE"
		refresh_oh_my_portable
	}
fi

############################################### core ###############################################
