from collections import defaultdict
import sys
import re

if len(sys.argv) < 2:
    print('Usage: {} {} filename'.format(sys.executable, sys.argv[0]))
    exit(1)

f = open(sys.argv[1], 'r')

d = defaultdict(int) 
for line in f.readlines():
    for word in re.split('\\W', line):
        d[word] += 1

f.close()

for key, value in d.items():
    print('{}: {}'.format(key, value))

