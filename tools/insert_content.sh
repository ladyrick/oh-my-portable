if (($# < 2)); then
	echo "Error! need target file and content."
	exit 1
fi

target_file="$1"
content="$2"
comment_mark="${3:-#}"

begin_mark="${comment_mark} oh-my-portable begin mark. don't edit"
end_mark="${comment_mark} oh-my-portable end mark. don't edit"

total_content="${begin_mark}
${content}
${end_mark}"

replace_count=$(perl -i -0pe '$c+=s/'"${begin_mark//\//\\\/}(:?.|\\n)*?${end_mark//\//\\\/}/${total_content//\//\\\/}"'/; END {print "$c"}' "$target_file")

if [[ -z "$replace_count" || $replace_count == 0 ]]; then
	echo -e "\e[32;1madded to \"$target_file\":\e[0m"
	echo "$total_content
"
	echo -n "
$total_content
" >>"$target_file"
fi
