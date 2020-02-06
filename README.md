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
regex search
re IGNORECASE
re compile
```

More
----
`rex` is a Python script.  It's compatible with 2.7+, but the shebang calls
`/usr/bin/env python3` because we live in the future.

Here's the `--help`:
```console
$ ./rex --help
usage: rex [-h] [-j] [-i] pattern

Extract substrings from lines of text using a regular expression.

positional arguments:
  pattern            Python-style regular expression against which to match
                     input lines

optional arguments:
  -h, --help         show this help message and exit
  -j, --json         output matches as an array of JSON strings, one array per
                     match
  -i, --ignore-case  match without making a distinction between upper case and
                     lower case

Read lines from standard input, and print results to standard output. If the
specified pattern contains subpatterns, then for each match found in each
input line, print a line of space-separated subpattern matches. If the
specified pattern does not contain subpatterns, then the entire match will be
treated as a single subpattern match.
```
