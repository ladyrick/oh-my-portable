# oh-my-portable

Oh-my-portable can help you sync your bash/vim/git configure through `ssh`.

Once you setup your configure, every time you login a remote host via `ssh`, the configures will be passed as well.

So the experience would be the same.

# Advantage

The best part is, oh-my-portable neither create any file in remote host, nor influence any other who is logged in the remote host (even with the same user).

It's totally session-level configure.

# How to use

## 1. Prepare your configures.

There are already some config files in `rc.d` recommanded by oh-my-portable.

You can edit these files directly, or create a directory `rc.d.private`, and constructure configure files just like which in `rc.d`.

## 2. Config and install

1. (Optional) Edit `config.sh` in root folder.
2. Run `source ./oh-my-portable.sh`
```shell 
source ./oh-my-portable.sh
```

## 3. Refresh oh-my-portable

```
omp reload
```

Every time you change your configure in `rc.d` or `rc.d.private`, please run this command to bring them into effect.

# Demo
There is a demo video shows how to install oh-my-portable, how to write a script and then use it in remote hosts.
It's pretty easy to use.

https://ladyrick.github.io/oh-my-portable/doc/demo.mp4
