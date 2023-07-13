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
		__OH_MY_PORTABLE_REMOTE_PROFILE_STRING=${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING//\'/\'\\\'\'}
		/usr/bin/env ssh -tq "${ssh_args[@]}" "$host" "
		__OH_MY_PORTABLE_REMOTE_PROFILE_STRING='${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING}' bash -c 'bash --rcfile <(
			cat /etc/profile
			{ cat ~/.bash_profile || cat ~/.bash_login || cat ~/.profile; } 2>/dev/null
			echo '\\''eval \"\${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING}\"'\\''
		)'"
	else
		local __OH_MY_PORTABLE_REMOTE_PROFILE_STRING=${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING:-$(cat $OH_MY_PORTABLE/dist/remote_profile.sh)}
		__OH_MY_PORTABLE_REMOTE_PROFILE_STRING=${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING//\'/\'\\\'\'\\\'\\\'\'\'\\\'\'}
		/usr/bin/env ssh -tq "${ssh_args[@]}" "$host" "bash -c '
		export __OH_MY_PORTABLE_REMOTE_PROFILE_STRING='\\''${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING}'\\''
		eval \"\${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING}\"
		${cmd//\'/\'\\\'\'}
		'"
	fi
}

if [[ "$OH_MY_PORTABLE" ]]; then
	function omp() {
		case "$1" in
		reload)
			source $OH_MY_PORTABLE/oh-my-portable.sh && echo -e '\e[32mFinished\e[0m' || echo -e '\e[31mError\e[0m'
			;;
		update)
			echo "[omp] update $OH_MY_PORTABLE/rc.d.private"
			if [[ -d "$OH_MY_PORTABLE/rc.d.private" ]]; then
				if [[ -d "$OH_MY_PORTABLE/rc.d.private/.git" ]]; then
					cd "$OH_MY_PORTABLE/rc.d.private"
					if [[ $(git remote) ]]; then
						echo '[omp] git pull rc.d.private'
						git pull
					else
						echo '[omp] rc.d.private is a local git repo. skip update'
					fi
				else
					echo '[omp] rc.d.private is not a git repo. skip update'
				fi
			else
				echo '[omp] rc.d.private not found. skip update'
			fi

			echo "[omp] update $OH_MY_PORTABLE"
			cd "$OH_MY_PORTABLE"
			git pull

			echo "[omp] reload $OH_MY_PORTABLE"

			omp reload
			;;
		config)
			echo $(OH_MY_PORTABLE="$OH_MY_PORTABLE" bash $OH_MY_PORTABLE/tools/parse_config.sh)
			;;
		run)
			bash $OH_MY_PORTABLE/bin/omprun "${@:2}"
			;;
		check-update)
			local need_update=0
			if [[ -d "$OH_MY_PORTABLE/rc.d.private/.git" ]]; then
				cd "$OH_MY_PORTABLE/rc.d.private"
				local remote=$(git remote)
				if [[ -n "$remote" ]]; then
					echo "checking $OH_MY_PORTABLE/rc.d.private"
					git fetch "$remote"
					if git status | head -n 2 | grep -q 'Your branch is behind'; then
						echo "$OH_MY_PORTABLE/rc.d.private needs to update"
						need_update=1
					fi
				fi
			fi

			cd "$OH_MY_PORTABLE"
			echo "checking $OH_MY_PORTABLE"
			git fetch "$(git remote)"
			if git status | head -n 2 | grep -q 'Your branch is behind'; then
				echo "$OH_MY_PORTABLE needs to update"
				need_update=1
			fi
			[[ "$need_update" == 0 ]] && echo "nothing to update"
			;;
		help)
			echo 'usage:
    omp reload: reload omp to load your change.
    omp update: update from remote repo.
    omp config: show omp config
    omp run: use omp as an interpreter to run a script.
    omp check-update: check update
    omp help: show this help message
'
			;;
		esac
	}
	function __omp_comp() {
		if [[ ${#COMP_WORDS[@]} == 2 ]]; then
			COMPREPLY=($(compgen -W 'reload update config help run check-update' "${COMP_WORDS[1]}"))
		else
			COMPREPLY=()
		fi
	}
	complete -F __omp_comp omp
else
	function omp() {
		echo "you are in remote host."
		return 1
	}
fi

############################################### core ###############################################
