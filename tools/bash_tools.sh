function ssh() {
	declare -a ssh_args
	while [[ $# != 0 ]]; do
		case "$1" in
		-[^bcDEeFIiJLlmOopQRSWw]+)
			ssh_args+=("$1")
			shift
			;;
		-[bcDEeFIiJLlmOopQRSWw])
			ssh_args+=("$1" "$2")
			shift 2
			;;
		*)
			if (($# > 1)); then
				ssh_args+=("$@")
			else
				__OH_MY_PORTABLE_REMOTE_PROFILE_STRING=${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING:-$(cat $OH_MY_PORTABLE/dist/remote_profile.sh)}
				ssh_args+=("$1" "-t" "bash --rcfile <(
					cat /etc/profile
					{ cat ~/.bash_profile || cat ~/.bash_login || cat ~/.profile; } 2>/dev/null
					echo 'export __OH_MY_PORTABLE_REMOTE_PROFILE_STRING='\"'\"'$(
						echo "$__OH_MY_PORTABLE_REMOTE_PROFILE_STRING" | sed "s/'/'\"'\"'\"'\"'\"'\"'\"'\"'/g"
					)'\"'\"
					echo 'source <(echo \"\${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING}\")'
				)")
			fi
			set --
			;;
		esac
	done
	/usr/bin/env ssh "${ssh_args[@]}"
}

function refresh_oh_my_portable() {
	if [[ "$OH_MY_PORTABLE" ]]; then
		bash $OH_MY_PORTABLE/oh-my-portable.sh 1>/dev/null && source ~/.bashrc && echo Finished. || echo Error.
	else
		echo "You are in remote host. Unable to refresh oh-my-portable."
	fi
}

######################################################################################################
