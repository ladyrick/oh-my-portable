function __oh_my_portable_ssh() {
	if [[ "$#" == "0" ]]; then
		/usr/bin/env ssh
	else
		local EOF_MARK=OH_MY_PORTABLE_EOF
		/usr/bin/env ssh "$@" -t "bash --rcfile <(cat '/etc/profile'
([ -r "'~/.bash_profile'" ] && cat "'~/.bash_profile'") || ([ -r "'~/.bash_login'" ] && cat "'~/.bash_login'") || ([ -r "'~/.profile'" ] && cat "'~/.profile'")
cat << '$EOF_MARK'
$(cat $OH_MY_PORTABLE/dist/inline_profile.sh)
$EOF_MARK
		)"
	fi
}

alias ssh="__oh_my_portable_ssh"
