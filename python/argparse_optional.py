#!/usr/bin/env python3
import argparse
import sys

parser = argparse.ArgumentParser()
parser.add_argument('--silent', action='store_true',
                    help='do not echo')
group = parser.add_mutually_exclusive_group(required=True)
group.add_argument('--list', metavar='actions', help="list the actions")
group.add_argument('--execute', metavar='actions', help="execute the actions")

args = parser.parse_args()

print(args)


