#!/usr/bin/env python3
import re
from collections import OrderedDict
import sys

re_ = re.compile(r"^([^=]+)=(.+)$")

if sys.version_info[0] == 2:
    readline = raw_input  # noqa
else:
    readline = input


def parse(line):
    match = re_.search(line)
    conf = match.group(1)
    value = match.group(2).replace("'", "'\\''")
    return conf, value


if len(sys.argv) <= 1:
    print("need to specify local_profile or remote_profile")
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
