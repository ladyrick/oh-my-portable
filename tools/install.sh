export OH_MY_PORTABLE_CONFIG="$(bash $OH_MY_PORTABLE/tools/parse_config.sh)"

bash $OH_MY_PORTABLE/tools/compile.sh

bash $OH_MY_PORTABLE/tools/insert_content.sh ~/.bashrc "source '$OH_MY_PORTABLE/oh-my-portable.sh'"

if [[ "$OH_MY_PORTABLE_CONFIG" =~ v ]]; then
	bash $OH_MY_PORTABLE/tools/insert_content.sh ~/.vimrc "source $OH_MY_PORTABLE/dist/.vimrc" '"'
fi

if [[ "$OH_MY_PORTABLE_CONFIG" =~ g ]]; then
	bash $OH_MY_PORTABLE/tools/insert_content.sh ~/.gitconfig "[include]
	path = $OH_MY_PORTABLE/dist/.gitconfig"
fi

if [[ "$OH_MY_PORTABLE_CONFIG" =~ t ]]; then
	bash $OH_MY_PORTABLE/tools/insert_content.sh ~/.tmux.conf "source '$OH_MY_PORTABLE/dist/.tmux.conf'"
fi

[[ -n "$OH_MY_PORTABLE_NO_INSTALL_PROMPT" ]] || echo 'Finished. Please restart the shell or run "source ~/.bashrc"'
