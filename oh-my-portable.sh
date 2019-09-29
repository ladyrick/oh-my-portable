#!/bin/bash

if [[ $# == 0 ]]; then
	if [[ $- == *i* ]]; then
		source $OH_MY_PORTABLE/dist/profile.sh
	else
		echo Directly run this script will do nothing.
		echo Please run \"source oh-my-portable.sh\" to bring it into effect.
	fi
else
	export OH_MY_PORTABLE=${OH_MY_PORTABLE:=$(cd $(dirname $0);pwd)}
	case "$1" in
	c) # compile.
		bash $OH_MY_PORTABLE/tools/compile.sh
		;;
	i) # compile and install.
		bash $OH_MY_PORTABLE/tools/compile.sh
		bash $OH_MY_PORTABLE/tools/install.sh
		;;
	cs) # compile. only patch ssh.
		bash $OH_MY_PORTABLE/tools/compile.sh s
		;;
	is) # compile and install. only patch ssh.
		bash $OH_MY_PORTABLE/tools/compile.sh s
		bash $OH_MY_PORTABLE/tools/install.sh
		;;
	*)
		echo unknown operator
		exit 1
		;;
	esac
fi
