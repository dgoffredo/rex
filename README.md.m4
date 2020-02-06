changequote(`{{{', `}}}')dnl
rex `/🦖/`
==========
Pull regular expression subpattern matches out of text line-by-line.

Why
---
Sometimes `sed`, `awk`, and even `perl` are just a pain in the ass.

What
----
```console
$ <rex ./rex '\b(r\w+)\.(\w+)'
esyscmd(<rex ./rex '\b(r\w+)\.(\w+)')dnl
```

More
----
`rex` is a Python script.  It's compatible with 2.7+, but the shebang calls
`/usr/bin/env python3` because we live in the future.

Here's the `--help`:
```console
$ ./rex --help
esyscmd(./rex --help)dnl
```
