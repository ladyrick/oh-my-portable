source $OH_MY_PORTABLE/tools/parse_config.sh
source $OH_MY_PORTABLE/tools/compile.sh

function __insert_content() {
	local target_file="$1"
	local content="$2"
	local comment_mark="${3:-#}"
	python3 $OH_MY_PORTABLE/tools/insert_content.py "$target_file" "$content" "$comment_mark"
}

__insert_content ~/.bashrc "source '$OH_MY_PORTABLE/oh-my-portable.sh'"

if [[ "$OH_MY_PORTABLE_CONFIG" =~ v ]]; then
	__insert_content ~/.vimrc "source $OH_MY_PORTABLE/dist/.vimrc" '"'
fi

if [[ "$OH_MY_PORTABLE_CONFIG" =~ g ]]; then
	__insert_content ~/.gitconfig "[include]
	path = $OH_MY_PORTABLE/dist/.gitconfig"
fi

if [[ "$OH_MY_PORTABLE_CONFIG" =~ t ]]; then
	__insert_content ~/.tmux.conf "source '$OH_MY_PORTABLE/dist/.tmux.conf'"
fi

[[ -n "$OH_MY_PORTABLE_NO_INSTALL_PROMPT" ]] || echo 'Finished. Please restart the shell or run "source ~/.bashrc"'
