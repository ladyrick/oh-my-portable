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
				ssh_args+=("$1" "-t" "bash --rcfile <(cat /etc/profile
for p in ~/.bash_profile ~/.bash_login ~/.profile; do [[ -r \$p ]] && cat \$p && break;done
cat << 'eof_ssh_patch___rand_key'
$(cat $OH_MY_PORTABLE/dist/remote_profile.sh)
eof_ssh_patch___rand_key
)")
			fi
			set --
			;;
		esac
	done
	/usr/bin/env ssh "${ssh_args[@]}"
}

function refresh_oh_my_portable() {
	bash $OH_MY_PORTABLE/oh-my-portable.sh 1>/dev/null && source ~/.bashrc && echo Finished. || echo Error.
}

######################################################################################################
