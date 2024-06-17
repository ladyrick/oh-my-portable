############################################# begin of core ###############################################

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
	else
		local __OH_MY_PORTABLE_REMOTE_PROFILE_STRING=${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING:-$(cat $OH_MY_PORTABLE/dist/remote_profile.sh)}
		local cmd_str="$__OH_MY_PORTABLE_REMOTE_PROFILE_STRING"
		local sed_replace="s/'/'\\\\''/g"
		if [[ -z "${cmd_set}" ]]; then
			cmd_str="__OH_MY_PORTABLE_REMOTE_PROFILE_STRING='$(sed "$sed_replace" <<<"$cmd_str")'"
			cmd_str="
				bash --rcfile <(
					echo '$(sed "$sed_replace" <<<"$cmd_str")'
					cat /etc/profile
					{ cat ~/.bash_profile || cat ~/.bash_login || cat ~/.profile; } 2>/dev/null
					echo 'eval \"\${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING}\"'
				)
			"
			cmd_str="bash -c '$(sed "$sed_replace" <<<"$cmd_str")'"
			/usr/bin/env ssh -tq "${ssh_args[@]}" "$host" "$cmd_str"
		else
			local __OH_MY_PORTABLE_REMOTE_PROFILE_STRING=${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING:-$(cat $OH_MY_PORTABLE/dist/remote_profile.sh)}
			cmd_str="
				__OH_MY_PORTABLE_REMOTE_PROFILE_STRING='$(sed "$sed_replace" <<<"$cmd_str")'
				eval \"\${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING}\"
				$cmd
			"
			cmd_str="bash -c '$(sed "$sed_replace" <<<"$cmd_str")'"
			/usr/bin/env ssh "${ssh_args[@]}" "$host" "$cmd_str"
		fi
	fi
}

if [[ "$OH_MY_PORTABLE" ]]; then
	function omp() {
		case "$1" in
		reload)
			bash "$OH_MY_PORTABLE/tools/install.sh"
			source $OH_MY_PORTABLE/oh-my-portable.sh && echo -e '\e[32mFinished\e[0m' || echo -e '\e[31mError\e[0m'
			;;
		update)
			# update in subshell to avoid changing current directory
			echo "[omp] update $OH_MY_PORTABLE/rc.d.private"
			if [[ -d "$OH_MY_PORTABLE/rc.d.private" ]]; then
				if [[ -d "$OH_MY_PORTABLE/rc.d.private/.git" ]]; then
					if [[ $(git -C "$OH_MY_PORTABLE/rc.d.private" remote) ]]; then
						echo '[omp] git pull rc.d.private'
						git -C "$OH_MY_PORTABLE/rc.d.private" pull
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
			git -C "$OH_MY_PORTABLE" pull

			echo "[omp] reload $OH_MY_PORTABLE"
			omp reload
			;;
		config)
			bash -c "$(cat "$OH_MY_PORTABLE/config.sh")"';for c in ${!portable_*}; do echo "$c=${!c}"; done'
			;;
		check-update)
			local need_update=0
			if [[ -d "$OH_MY_PORTABLE/rc.d.private/.git" ]]; then
				local remote=$(git -C "$OH_MY_PORTABLE/rc.d.private" remote)
				if [[ -n "$remote" ]]; then
					echo "checking $OH_MY_PORTABLE/rc.d.private"
					git -C "$OH_MY_PORTABLE/rc.d.private" fetch "$remote"
					if git -C "$OH_MY_PORTABLE/rc.d.private" status | head -n 2 | grep -q 'Your branch is behind'; then
						echo "$OH_MY_PORTABLE/rc.d.private needs to update"
						need_update=1
					fi
				fi
			fi
			echo "checking $OH_MY_PORTABLE"
			git -C "$OH_MY_PORTABLE" fetch "$(git -C "$OH_MY_PORTABLE" remote)"
			if git -C "$OH_MY_PORTABLE" status | head -n 2 | grep -q 'Your branch is behind'; then
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
    omp check-update: check update
    omp help: show this help message
'
			;;
		*)
			echo "unknown command '$1'. try \`omp help\` for help."
			return 1
			;;
		esac
	}
	function __omp_comp() {
		if [[ ${#COMP_WORDS[@]} == 2 ]]; then
			COMPREPLY=($(compgen -W 'reload update config help check-update' "${COMP_WORDS[1]}"))
		else
			COMPREPLY=()
		fi
	}
	complete -F __omp_comp omp
else
	function omp() {
		echo "invalid usage: you are in remote host."
		return 1
	}
fi

############################################### end of core ###############################################
