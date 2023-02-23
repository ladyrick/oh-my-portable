#!/usr/bin/env python3
import os
import re
import sys

if len(sys.argv) < 3:
    print("Error! need target file and content.")
    sys.exit(1)

target_file = sys.argv[1]
content = sys.argv[2]
comment_mark = "#" if len(sys.argv) < 4 else sys.argv[3]

begin_mark = "oh-my-portable begin mark. don't edit"
end_mark = "oh-my-portable end mark. don't edit"

pattern = f"(?:\n|^)[{comment_mark}] {begin_mark}\n(?:.|\n)*?\n[{comment_mark}] {end_mark}(?:\n|$)"
replace_content = f"\n{comment_mark} {begin_mark}\n{content.strip()}\n{comment_mark} {end_mark}\n"

if os.path.exists(target_file):
    with open(target_file) as f:
        file_content = f.read()
    replace_file_content, n = re.subn(pattern, replace_content, file_content, re.MULTILINE)
    if n == 0:
        print("\033[32;1madded to {}\033[0m{}".format(target_file, replace_content))
        replace_file_content = replace_file_content + replace_content
else:
    replace_file_content = replace_content


with open(target_file, "w") as f:
    f.write(replace_file_content)
