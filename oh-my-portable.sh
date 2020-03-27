#!/bin/bash
export OH_MY_PORTABLE="$(cd "$(dirname "$BASH_SOURCE[0]")" && pwd)"
source $OH_MY_PORTABLE/config.sh
OH_MY_PORTABLE_CONFIG=
[[ "$__only_patch_ssh" == "true" ]] && OH_MY_PORTABLE_CONFIG=o$OH_MY_PORTABLE_CONFIG
[[ "$__portable_vim" == "true" ]] && OH_MY_PORTABLE_CONFIG=v$OH_MY_PORTABLE_CONFIG
[[ "$__portable_git" == "true" ]] && OH_MY_PORTABLE_CONFIG=g$OH_MY_PORTABLE_CONFIG
[[ "$__portable_bash" == "true" ]] && OH_MY_PORTABLE_CONFIG=b$OH_MY_PORTABLE_CONFIG
export OH_MY_PORTABLE_CONFIG

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	bash $OH_MY_PORTABLE/tools/compile.sh
	bash $OH_MY_PORTABLE/tools/install.sh
else
	source $OH_MY_PORTABLE/dist/profile.sh
fi
