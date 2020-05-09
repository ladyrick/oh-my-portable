rm -rf $OH_MY_PORTABLE/dist
mkdir -p $OH_MY_PORTABLE/dist/scripts

__rand_key=$(openssl rand -hex 8)

function __merge_files() {
	for f in "$@"; do
		[[ -r "$f" ]] && cat "$f"
		cat <<<""
	done
}

function __make_remote_profile() {
	local remote_profile="$OH_MY_PORTABLE/dist/remote_profile.sh"
	touch "$remote_profile" || return 1

	if [[ "$OH_MY_PORTABLE_CONFIG" =~ v ]]; then
		# portable vim config
		cat >>"$remote_profile" <<-EOF
			function vim() {
				/usr/bin/env vim -u <(cat <<'eof_vim_${__rand_key}'
					$(__merge_files $OH_MY_PORTABLE/rc.d/vimrc.d/* $OH_MY_PORTABLE/rc.d.private/vimrc.d/*)
				eof_vim_${__rand_key}
				) "\$@"
			}
		EOF
	fi

	if [[ "$OH_MY_PORTABLE_CONFIG" =~ g ]]; then
		# portable git config
		cat >>"$remote_profile" <<-EOF
			function git() {
				$(git config -f <(__merge_files $OH_MY_PORTABLE/rc.d/gitconfig.d/* $OH_MY_PORTABLE/rc.d.private/gitconfig.d/*) --list | python3 $OH_MY_PORTABLE/tools/git_with_config.py remote_profile)
			}
		EOF
	fi

	if [[ "$OH_MY_PORTABLE_CONFIG" =~ b ]]; then
		# portable bash config
		__merge_files $OH_MY_PORTABLE/rc.d/bashrc.d/* $OH_MY_PORTABLE/rc.d.private/bashrc.d/* >>"$remote_profile"
	fi

	if [[ "$OH_MY_PORTABLE_CONFIG" =~ s ]]; then
		# portable scripts
		for script_file in $OH_MY_PORTABLE/rc.d/scripts/* $OH_MY_PORTABLE/rc.d.private/scripts/*; do
			[[ -r "$script_file" ]] || continue
			local file_name="$(basename "$script_file")"
			local file_name=${file_name// /_}
			local file_shebang="$(head -n 1 "$script_file" | grep '#!/')"
			[[ -z "$file_shebang" ]] && echo -e "\e[31;1m$script_file\e[0m doesn't have a shebang. Ignoring it." 1>&2 && continue
			cat >>"$remote_profile" <<-EOF
				function $file_name {
					${file_shebang:2} <(cat <<'eof_${file_name}_${__rand_key}'
						$(cat "$script_file")
					eof_${file_name}_${__rand_key}
					) "\$@"
				}
			EOF
		done
	fi
}

function __make_local_profile() {
	local local_profile="$OH_MY_PORTABLE/dist/local_profile.sh"
	cat $OH_MY_PORTABLE/tools/bash_tools.sh | sed "s/__rand_key/$__rand_key/" >>"$local_profile"
	[[ "$OH_MY_PORTABLE_CONFIG" =~ o ]] && return
	if [[ "$OH_MY_PORTABLE_CONFIG" =~ b ]]; then
		__merge_files $OH_MY_PORTABLE/rc.d/bashrc.d/* $OH_MY_PORTABLE/rc.d.private/bashrc.d/* >>"$local_profile"
	fi
	if [[ "$OH_MY_PORTABLE_CONFIG" =~ v ]]; then
		__merge_files $OH_MY_PORTABLE/rc.d/vimrc.d/* $OH_MY_PORTABLE/rc.d.private/vimrc.d/* >>$OH_MY_PORTABLE/dist/vimrc
	fi
	if [[ "$OH_MY_PORTABLE_CONFIG" =~ g ]]; then
		eval $(git config -f <(__merge_files $OH_MY_PORTABLE/rc.d/gitconfig.d/* $OH_MY_PORTABLE/rc.d.private/gitconfig.d/*) --list | python3 $OH_MY_PORTABLE/tools/git_with_config.py local_profile)
	fi
	if [[ "$OH_MY_PORTABLE_CONFIG" =~ s ]]; then
		cp $OH_MY_PORTABLE/rc.d/scripts/* $OH_MY_PORTABLE/rc.d.private/scripts/* $OH_MY_PORTABLE/dist/scripts/ 2>/dev/null
		chmod a+x $OH_MY_PORTABLE/dist/scripts/* 2>/dev/null
		echo 'export PATH="$PATH:$OH_MY_PORTABLE/dist/scripts"' >>"$local_profile"
	fi
}

__make_local_profile
__make_remote_profile

python3 $OH_MY_PORTABLE/tools/pre_run.py $OH_MY_PORTABLE/dist/*.sh
