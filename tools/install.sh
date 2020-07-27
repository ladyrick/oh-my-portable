[[ -f ~/.bashrc ]] || touch ~/.bashrc
grep "source \"$OH_MY_PORTABLE/oh-my-portable.sh\"" ~/.bashrc &>/dev/null || {
	sed -i '/source \".*oh-my-portable.sh\"/d' ~/.bashrc
	echo -e "\nsource \"$OH_MY_PORTABLE/oh-my-portable.sh\"" >>~/.bashrc
}

function __backup_and_copy() {
	[[ -z "$1" || -z "$2" ]] && return 1
	[[ -f "$2" && ! -f "$2".oh_my_portable_backup ]] && cp "$2" "$2".oh_my_portable_backup
	cp "$1" "$2" 2>/dev/null
}

if [[ "$OH_MY_PORTABLE_CONFIG" =~ v ]]; then
	__backup_and_copy $OH_MY_PORTABLE/dist/.vimrc ~/.vimrc 2>/dev/null
fi
if [[ "$OH_MY_PORTABLE_CONFIG" =~ g ]]; then
	__backup_and_copy $OH_MY_PORTABLE/dist/.gitconfig ~/.gitconfig 2>/dev/null
fi

echo Finished. Please restart the shell or run \"source "~/.bashrc"\"
