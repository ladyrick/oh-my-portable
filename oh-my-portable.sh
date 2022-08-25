#!/bin/bash
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	OH_MY_PORTABLE="$(cd "$(dirname "$BASH_SOURCE[0]")" && pwd)"
	source $OH_MY_PORTABLE/config.sh
	OH_MY_PORTABLE_CONFIG=
	[[ "$__only_patch_ssh" == "true" ]] && OH_MY_PORTABLE_CONFIG=o$OH_MY_PORTABLE_CONFIG
	[[ "$__portable_vim" == "true" ]] && OH_MY_PORTABLE_CONFIG=v$OH_MY_PORTABLE_CONFIG
	[[ "$__portable_git" == "true" ]] && OH_MY_PORTABLE_CONFIG=g$OH_MY_PORTABLE_CONFIG
	[[ "$__portable_bash" == "true" ]] && OH_MY_PORTABLE_CONFIG=b$OH_MY_PORTABLE_CONFIG
	[[ "$__portable_script" == "true" ]] && OH_MY_PORTABLE_CONFIG=s$OH_MY_PORTABLE_CONFIG
	[[ "$__portable_tmux" == "true" ]] && OH_MY_PORTABLE_CONFIG=t$OH_MY_PORTABLE_CONFIG
	source $OH_MY_PORTABLE/tools/compile.sh
	source $OH_MY_PORTABLE/tools/install.sh $1
else
	# when your remote host has installed, don't use their.
	if [[ -z ${__OH_MY_PORTABLE_REMOTE_PROFILE_STRING+x} ]]; then
		OH_MY_PORTABLE="$(cd "$(dirname "$BASH_SOURCE[0]")" && pwd)"
		source $OH_MY_PORTABLE/dist/local_profile.sh
	fi
fi
