#!/usr/bin/env python3

import argparse
import fileinput
import json
import re
import signal
import sys


def parse_command_line(args):
    parser = argparse.ArgumentParser(description=
        'Extract substrings from lines of text using a regular expression.',
        epilog=
"""Read lines from the optionally specified input files (or from standard input
if no files are specified), and print results to standard output.

If the specified pattern contains subpatterns, then for each match found in
each input line, print a line of space-separated subpattern matches.

If the specified pattern does not contain subpatterns, then the entire match
will be treated as a single subpattern match.""")


    parser.add_argument('-j', '--json', action='store_true', help=
        'output matches as an array of JSON strings, one array per match')
    parser.add_argument('-i', '--ignore-case', dest='ignore_case',
                        action='store_true', help=
        'match without making a distinction between upper case and lower case')
    parser.add_argument('pattern', help=
        'Python-style regular expression against which to match input lines')
    parser.add_argument('files', nargs='*', help=
        'Paths to files to read line-by-line.  Standard input ("-") is the '
        'default.')

    return parser.parse_args(args)


def all_matches(regex, line):
    """Find all matches of the regex from the line of text.  Yield tuples of
    subgroup matches, one tuple for each match.
    """
    start = 0
    while start < len(line):
        match = regex.search(line, start)
        if match is None:
            break

        # If there are no subpattern matches, then use the entire match as if
        # it were one subpattern match.
        groups = match.groups() or (match.group(0),)
        yield groups
        
        # Try the rest of the line.
        start = match.end()


def main(args):
    options = parse_command_line(args)

    flags = 0
    if options.ignore_case:
        flags |= re.IGNORECASE

    regex = re.compile(options.pattern, flags)

    for line in fileinput.input(options.files):
        for groups in all_matches(regex, line):
            if options.json:
                json.dump(groups, sys.stdout)
            else:
                sys.stdout.write(' '.join(groups))

            sys.stdout.write('\n')


if __name__ == '__main__':
    signal.signal(signal.SIGINT, signal.SIG_DFL) # signal signal signal signal
    main(sys.argv[1:])
