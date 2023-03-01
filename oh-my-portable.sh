#!/bin/bash
OH_MY_PORTABLE="$(cd "$(dirname "$BASH_SOURCE[0]")" && pwd)"

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	# you are running this file.
	OH_MY_PORTABLE="$OH_MY_PORTABLE" bash "$OH_MY_PORTABLE/tools/install.sh"
	echo 'Finished. Please restart the shell or run "source ~/.bashrc"'
else
	# you are sourcing this file.

	# when you login a remote host which already install oh-my-portable
	# the 'source xxx/oh-my-portable.sh' in the remote .bashrc will overwrite your tools.
	# so skip it.
	if [[ -z ${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING+x} ]]; then
		if [[ ! "${BASH_SOURCE[1]}" =~ bashrc ]]; then
			# when not source from bashrc, do install.
			# this allow you to install and activate at the same time by sourcing this file from terminal.
			OH_MY_PORTABLE="$OH_MY_PORTABLE" bash "$OH_MY_PORTABLE/tools/install.sh"
		fi
		source "$OH_MY_PORTABLE/dist/local_profile.sh"
	fi
fi
