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

	# vim
	cat >>$inline_profile <<-EOF
		alias vim='vim -u <(echo "$(__merge_files $OH_MY_PORTABLE/rc.d/vimrc.d/* $OH_MY_PORTABLE/rc.d.private/vimrc.d/*)")'
	EOF

	# bashrc
	__merge_files $OH_MY_PORTABLE/rc.d/bashrc.d/* $OH_MY_PORTABLE/rc.d.private/bashrc.d/* >>$inline_profile

	# gitconfig
	cat >>$inline_profile <<-EOF
		function __oh_my_portable_git() {
			$(git config -f <(__merge_files $OH_MY_PORTABLE/rc.d/gitconfig.d/* $OH_MY_PORTABLE/rc.d.private/gitconfig.d/*) --list | python $OH_MY_PORTABLE/tools/git_with_config.py inline_profile)
		}
		alias git=__oh_my_portable_git
	EOF
}

function __make_profile() {
	__merge_files $OH_MY_PORTABLE/rc.d/bashrc.d/* $OH_MY_PORTABLE/rc.d.private/bashrc.d/* >>$OH_MY_PORTABLE/dist/profile.sh
	__merge_files $OH_MY_PORTABLE/rc.d/vimrc.d/* $OH_MY_PORTABLE/rc.d.private/vimrc.d/* >>$OH_MY_PORTABLE/dist/vimrc
	bash <(git config -f <(__merge_files $OH_MY_PORTABLE/rc.d/gitconfig.d/* $OH_MY_PORTABLE/rc.d.private/gitconfig.d/*) --list | python $OH_MY_PORTABLE/tools/git_with_config.py profile)
}

function __patch_ssh() {
	__merge_files $OH_MY_PORTABLE/tools/ssh_patch.sh >>$OH_MY_PORTABLE/dist/profile.sh
}

__make_inline_profile

if [[ "$1" == "s" ]]; then
	__patch_ssh
	echo 'export OH_MY_PORTABLE_ONLY_PATCH_SSH=1' >>$OH_MY_PORTABLE/dist/profile.sh
else
	__make_profile
	__patch_ssh
fi

cat >>$OH_MY_PORTABLE/dist/profile.sh <<-'EOF'
	function refresh_oh_my_portable() {
		local flag=i
		[[ -n "$OH_MY_PORTABLE_ONLY_PATCH_SSH" ]] && flag=is
		$OH_MY_PORTABLE/oh-my-portable.sh $flag 1>/dev/null && source ~/.bashrc && echo Finished. || echo Error.
	}
EOF

$OH_MY_PORTABLE/tools/pre_run.py $OH_MY_PORTABLE/dist/*.sh
