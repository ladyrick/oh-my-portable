#!/usr/bin/env bash

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	# you are running this file.
	if [[ "$1" != install ]]; then
		echo 'Please `source` this file.'
		echo 'If you want to install, use `bash "'"$0"'" install`'
	else
		cd "$(dirname "$0")" && bash tools/install.sh
	fi
else
	# you are sourcing this file.

	# when you login a remote host which already install oh-my-portable
	# the 'source xxx/oh-my-portable.sh' in the remote .bashrc will overwrite your tools.
	# so skip it.
	if [[ -z ${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING+x} ]]; then
		OH_MY_PORTABLE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
		if [[ -z "${BASH_SOURCE[1]}" ]]; then
			# when source from terminal or `bash -c`, do install/reinstall.
			# this allow you to install and activate at the same time by sourcing this file from terminal.
			bash "$OH_MY_PORTABLE/tools/install.sh"
		fi && source "$OH_MY_PORTABLE/dist/local_profile.sh"
	fi
fi
