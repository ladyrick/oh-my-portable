function keygen() {
    declare -i keylen
    if [[ -z "$1" ]]; then
        keylen=32
    else
        keylen="$1" || {
            echo "need an integer."
            return 1
        }
        ((keylen <= 0)) && return 0
    fi
    key=$(openssl rand -hex $(((keylen + 1) / 2)))
    echo ${key:0:${keylen}}
}
