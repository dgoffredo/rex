#!/usr/bin/env python3

import argparse
import json
import re
import sys


def parse_command_line(args):
    parser = argparse.ArgumentParser(description=
        'Extract substrings from lines of text using a regular expression.',
        epilog=
"""Read lines from standard input, and print results to standard output.
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

    return parser.parse_args(args)


def main(args):
    options = parse_command_line(args)

    flags = 0
    if options.ignore_case:
        flags |= re.IGNORECASE

    regex = re.compile(options.pattern, flags)

    for line in sys.stdin:
        # extract all matches
        start = 0
        while start < len(line):
            match = regex.search(line, start)
            if match is None:
                break

            # `match.groups()` is a tuple of the subpattern matches.  Either
            # print them separated by spaces, or print as JSON.
            # First, though, if there are no subpattern matches, then use the
            # entire match as if it were one subpattern match.
            groups = match.groups()
            if not groups:
                groups = (match.group(0),)

            if options.json:
                json.dump(groups, sys.stdout)
            else:
                sys.stdout.write(' '.join(groups))

            sys.stdout.write('\n')
            
            # Try the rest of the line.
            start = match.end()


if __name__ == '__main__':
    main(sys.argv[1:])
