#!/usr/bin/env python3
import re
import subprocess


def pre_run(filename):
    try:
        with open(filename, "r", encoding="utf-8") as f:
            filecontent = f.read()
    except:
        print("File not found: %s" % filename)
        return

    to_replace = []
    for it in re.finditer(r"\$\{PRE_RUN_BEGIN\}(.*?)\$\{PRE_RUN_END\}", filecontent, re.S):
        pre_run_cmd = it.group(1)
        pre_run_ans = subprocess.check_output(["bash", "-c", pre_run_cmd]).decode("utf-8").strip()
        to_replace.append((it.group(0), "%s" % pre_run_ans))

    if to_replace:
        for rep in to_replace:
            filecontent = filecontent.replace(rep[0], rep[1], 1)

        with open(filename, "w", encoding="utf-8") as f:
            f.write(filecontent)


if __name__ == "__main__":
    import sys
    for filename in sys.argv[1:]:
        pre_run(filename)
