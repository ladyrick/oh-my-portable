#!/bin/bash

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	# you are running this file.

	export OH_MY_PORTABLE="$(cd "$(dirname "$BASH_SOURCE[0]")" && pwd)"
	source $OH_MY_PORTABLE/tools/install.sh
else
	# you are sourcing this file.

	# when you login a remote host which already install oh-my-portable
	# the 'source xxx/oh-my-portable.sh' in the remote .bashrc will overwrite your tools.
	# so skip it.
	if [[ -z ${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING+x} ]]; then
		OH_MY_PORTABLE="$(cd "$(dirname "$BASH_SOURCE[0]")" && pwd)"
		source $OH_MY_PORTABLE/dist/local_profile.sh
	fi
fi
