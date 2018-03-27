from collections import defaultdict
import fileinput

f = defaultdict(int)
start = False

for line in fileinput.input():
    if line.startswith('%%'):
        start = True
    if start:
        for c in line:
            if f[c] < 2:
                print(c)
                f[c] += 1
            