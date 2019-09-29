# oh-my-portable

Oh-my-portable can help you sync your bash/vim/git configure through `ssh`.

Once you setup your configure, every time you login a remote host via `ssh`, the configures will be passed as well.

So the experience would be the same.

# Advantage

The best part is, oh-my-portable neither create any file in remote host, nor influence any other who is logged in the remote host (even with the same user).

It's totally session-level configure.

# How to use

## 1. Prepare your configures.

There are already some configures in rc.d recommanded by oh-my-portable.

To prepare your own configure, make a directory `rc.d.private`, and constructure configure files just like which in `rc.d`.

## 2. Install

There are two different ways to install.

### 2.1 Only patch ssh

```
./oh-my-portable.sh is
```

In this way, you can only patch the command `ssh`.

By doing this, every time you login a remote host via `ssh`, the configures will be passed as well.

But your own bash would not be effected.

### 2.2 Install to your bash

```
./oh-my-portable.sh i
```

In this way, not only the command `ssh`, but also your `bash`, is patched.

So you can keep a same experience in your local bash and the remote host.

## 3. Refresh oh-my-portable

```
refresh_oh_my_portable
```

Every time you change your configure in `rc.d` or `rc.d.private`, please run this command to bring them into effect.
