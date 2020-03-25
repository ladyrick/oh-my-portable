[[ -f ~/.bashrc ]] || touch ~/.bashrc
grep "export OH_MY_PORTABLE=\"$OH_MY_PORTABLE\" && source \"\$OH_MY_PORTABLE/oh-my-portable.sh\"" ~/.bashrc || {
	sed -i '/source \"$OH_MY_PORTABLE\/oh-my-portable.sh\"/d' ~/.bashrc
	echo "export OH_MY_PORTABLE=\"$OH_MY_PORTABLE\" && source \"\$OH_MY_PORTABLE/oh-my-portable.sh\"" >>~/.bashrc
}

function __backup_and_copy() {
	[[ -z "$1" || -z "$2" ]] && return 1
	[[ -f "$2" && ! -f "$2".oh_my_portable_backup ]] && cp "$2" "$2".oh_my_portable_backup
	cp "$1" "$2" 2>/dev/null
}

__backup_and_copy $OH_MY_PORTABLE/dist/vimrc ~/.vimrc 2>/dev/null
__backup_and_copy $OH_MY_PORTABLE/dist/.gitconfig ~/.gitconfig 2>/dev/null

echo Finished. Please restart the shell or run \"source "~/.bashrc"\"
