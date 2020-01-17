function keygen() {
	local bytes="$1"
	((bytes == 0)) && bytes=32
	cat /dev/urandom | od -x -w$bytes | head -n 1 | cut -d ' ' -f 2-|tr -d ' '
}
