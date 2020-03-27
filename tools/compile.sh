rm -rf $OH_MY_PORTABLE/dist
mkdir $OH_MY_PORTABLE/dist

function __merge_files() {
	for f in "$@"; do
		[[ -f "$f" ]] && cat "$f"
		cat <<<""
	done
}

function __make_inline_profile() {
	local inline_profile=$OH_MY_PORTABLE/dist/inline_profile.sh
	touch $inline_profile || return 1

	if [[ "$OH_MY_PORTABLE_CONFIG" =~ v ]]; then
		# portable vim config
		cat >>$inline_profile <<-EOF
			alias vim='vim -u <(echo "$(__merge_files $OH_MY_PORTABLE/rc.d/vimrc.d/* $OH_MY_PORTABLE/rc.d.private/vimrc.d/*)")'
		EOF
	fi

	if [[ "$OH_MY_PORTABLE_CONFIG" =~ b ]]; then
		# portable bash config
		__merge_files $OH_MY_PORTABLE/rc.d/bashrc.d/* $OH_MY_PORTABLE/rc.d.private/bashrc.d/* >>$inline_profile
	fi

	if [[ "$OH_MY_PORTABLE_CONFIG" =~ g ]]; then
		# portable git config
		cat >>$inline_profile <<-EOF
			function __oh_my_portable_git() {
				$(git config -f <(__merge_files $OH_MY_PORTABLE/rc.d/gitconfig.d/* $OH_MY_PORTABLE/rc.d.private/gitconfig.d/*) --list | python3 $OH_MY_PORTABLE/tools/git_with_config.py inline_profile)
			}
			alias git=__oh_my_portable_git
		EOF
	fi
}

function __make_profile() {
	if [[ "$OH_MY_PORTABLE_CONFIG" =~ b ]]; then
		__merge_files $OH_MY_PORTABLE/rc.d/bashrc.d/* $OH_MY_PORTABLE/rc.d.private/bashrc.d/* >>$OH_MY_PORTABLE/dist/profile.sh
	fi
	if [[ "$OH_MY_PORTABLE_CONFIG" =~ v ]]; then
		__merge_files $OH_MY_PORTABLE/rc.d/vimrc.d/* $OH_MY_PORTABLE/rc.d.private/vimrc.d/* >>$OH_MY_PORTABLE/dist/vimrc
	fi
	if [[ "$OH_MY_PORTABLE_CONFIG" =~ g ]]; then
		bash <(git config -f <(__merge_files $OH_MY_PORTABLE/rc.d/gitconfig.d/* $OH_MY_PORTABLE/rc.d.private/gitconfig.d/*) --list | python3 $OH_MY_PORTABLE/tools/git_with_config.py profile)
	fi
}

function __patch_ssh() {
	__merge_files $OH_MY_PORTABLE/tools/ssh_patch.sh >>$OH_MY_PORTABLE/dist/profile.sh
}

__make_inline_profile

__patch_ssh
if [[ ! "$OH_MY_PORTABLE_CONFIG" =~ o ]]; then
	__make_profile
fi

cat >>$OH_MY_PORTABLE/dist/profile.sh <<-'EOF'
	function refresh_oh_my_portable() {
		bash $OH_MY_PORTABLE/oh-my-portable.sh 1>/dev/null && source ~/.bashrc && echo Finished. || echo Error.
	}
EOF

python3 $OH_MY_PORTABLE/tools/pre_run.py $OH_MY_PORTABLE/dist/*.sh
