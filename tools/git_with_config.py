#!/usr/bin/env python
import re
from collections import OrderedDict
import sys

re_ = re.compile(r"^([^=]+)=(.+)$")

def readline():
    if sys.version_info.major == 2:
        return raw_input()
    else:
        return input()

def parse(line):
    match = re_.search(line)
    conf = match.group(1)
    value = match.group(2).replace("'", "'\"'\"'")
    return conf, value


if __name__ == "__main__":
    if len(sys.argv) <= 1:
        sys.exit(1)
    configs = OrderedDict()
    while True:
        try:
            conf, value = parse(readline())
            configs[conf] = value  # override old configs
        except EOFError:
            if sys.argv[1] == "local_profile":
                for conf, value in configs.items():
                    print("HOME=$OH_MY_PORTABLE/dist git config --global '{}' '{}';".format(conf, value))
            elif sys.argv[1] == "remote_profile":
                print("GIT_CONFIG_NOGLOBAL=1 HOME= XDG_CONFIG_HOME= /usr/bin/env git \\")
                for conf, value in configs.items():
                    print("-c '{}'='{}' \\".format(conf, value))
                print('"$@"')
            else:
                exit(1)
            break
