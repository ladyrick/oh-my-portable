[[ "$0" != "${BASH_SOURCE[0]}" ]] && echo "run me. don't source me." && return 1
cd "$(dirname "$0")"/..
proj_dir="$(pwd)"

source config.sh

rm -rf dist
mkdir -p dist/scripts

function merge_files() {
	for f in "$@"; do
		[[ -r "$f" ]] && echo && cat "$f" && echo
	done
}

function make_remote_profile() {
	local remote_profile="dist/remote_profile.sh"
	touch "$remote_profile" || return 1

	merge_files tools/core.sh >>"$remote_profile"

	if [[ "$portable_vim" == true ]]; then
		# portable vim config
		cat >>"$remote_profile" <<-EOF

			function vim() {
				/usr/bin/env vim -u <(echo '
					:set nocompatible
					$(merge_files rc.d/vimrc.d/* rc.d.private/vimrc.d/* | sed "s/'/'\\\\''/g")
				') "\$@"
			}

		EOF
	fi

	if [[ "$portable_git" == true ]]; then
		# portable git config
		if which git >/dev/null; then
			cat >>"$remote_profile" <<-EOF

				function git() {
					$(git config -f <(merge_files rc.d/gitconfig.d/* rc.d.private/gitconfig.d/*) --list | bash tools/git_with_config.sh remote)
				}

			EOF
		fi
	fi

	if [[ "$portable_bash" == true ]]; then
		# portable bash config
		merge_files rc.d/bashrc.d/* rc.d.private/bashrc.d/* >>"$remote_profile"
	fi

	if [[ "$portable_script" == true ]]; then
		# portable scripts
		for script_file in rc.d/scripts/* rc.d.private/scripts/*; do
			[[ -r "$script_file" ]] || continue
			local file_name="$(basename "$script_file")"
			if [[ ! "$file_name" =~ ^[a-zA-Z][a-zA-Z0-9]+$ ]]; then
				echo -e "\e[31;1m$script_file\e[0m has an invalid script name. Ignoring it." 1>&2
				continue
			fi
			local file_shebang="$(head -n 1 "$script_file" | grep '#!/')"
			if [[ -z "$file_shebang" ]]; then
				echo -e "\e[31;1m$script_file\e[0m doesn't have a shebang. Ignoring it." 1>&2
				continue
			fi
			cat >>"$remote_profile" <<-EOF

				function $file_name {
					${file_shebang:2} <(echo '
						$(cat "$script_file" | sed "s/'/'\\\\''/g")
					') "\$@"
				}

			EOF
		done
	fi

	if [[ "$portable_tmux" == true ]]; then
		# portable tmux config
		cat >>"$remote_profile" <<-EOF

			function tmux() {
				/usr/bin/env tmux -f <(echo '
					$(merge_files rc.d/tmux.conf.d/* rc.d.private/tmux.conf.d/* | sed "s/'/'\\\\''/g")
				') "\$@"
			}

		EOF
	fi
}

function make_local_profile() {
	local local_profile="dist/local_profile.sh"
	echo "unset __OH_MY_PORTABLE_REMOTE_PROFILE_STRING" >>"$local_profile"
	merge_files tools/core.sh >>"$local_profile"
	[[ "$portable_ssh_only" == true ]] && return
	if [[ "$portable_bash" == true ]]; then
		merge_files rc.d/bashrc.d/* rc.d.private/bashrc.d/* >>"$local_profile"
	fi
	if [[ "$portable_vim" == true ]]; then
		merge_files rc.d/vimrc.d/* rc.d.private/vimrc.d/* >>dist/.vimrc
	fi
	if [[ "$portable_git" == true ]]; then
		if which git >/dev/null; then
			eval "$(git config -f <(merge_files rc.d/gitconfig.d/* rc.d.private/gitconfig.d/*) --list | bash tools/git_with_config.sh local)"
		fi
	fi
	if [[ "$portable_script" == true ]]; then
		cp -f rc.d/scripts/* dist/scripts/ 2>/dev/null
		cp -f rc.d.private/scripts/* dist/scripts/ 2>/dev/null
		chmod a+x dist/scripts/* 2>/dev/null
		echo 'export PATH="$PATH:'"$proj_dir/bin:$proj_dir"'/dist/scripts"' >>"$local_profile"
	fi
	if [[ "$portable_tmux" == true ]]; then
		merge_files rc.d/tmux.conf.d/* rc.d.private/tmux.conf.d/* >>dist/.tmux.conf
	fi
}

make_local_profile
make_remote_profile
