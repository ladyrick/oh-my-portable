[[ "$0" != "${BASH_SOURCE[0]}" ]] && echo "run me. don't source me." && return 1
cd "$(dirname "$0")"

proj_dir="$(cd .. && pwd)"
if [[ "$proj_dir" =~ \ |\' ]]; then
	echo "Error: project path contains space or single quote. please move the project to another path."
	echo "$proj_dir"
	exit 1
fi

bash compile.sh

source ../config.sh # get configs

bash insert_content.sh ~/.bashrc "source '$proj_dir/oh-my-portable.sh'"

if [[ "$portable_vim" == true ]]; then
	bash insert_content.sh ~/.vimrc "source $proj_dir/dist/.vimrc" '"'
fi

if [[ "$portable_git" == true ]]; then
	bash insert_content.sh ~/.gitconfig "[include]
	path = $proj_dir/dist/.gitconfig"
fi

if [[ "$portable_tmux" == true ]]; then
	bash insert_content.sh ~/.tmux.conf "source '$proj_dir/dist/.tmux.conf'"
fi
