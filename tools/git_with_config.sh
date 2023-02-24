profile_type="$1"

declare -A configs
while IFS== read conf value; do
	configs[${conf//\'/\'\\\'\'}]="${value//\'/\'\\\'\'}"
done

if [[ "$profile_type" == "local" ]]; then
	for conf in ${!configs[@]}; do
		echo "HOME=$OH_MY_PORTABLE/dist git config --global '$conf' '${configs[$conf]}';"
	done
elif [[ "$profile_type" == "remote" ]]; then
	echo 'GIT_CONFIG_NOGLOBAL=1 HOME= XDG_CONFIG_HOME= /usr/bin/env git \'
	for conf in ${!configs[@]}; do
		echo "-c '$conf'='${configs[$conf]}' \\"
	done
	echo '"$@"'
else
	echo "invalid profile type: '$profile_type'"
	exit 1
fi
