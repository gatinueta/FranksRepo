import fileinput
from collections import defaultdict

freq = defaultdict(int)
for line in fileinput.input():
    for c in line:
        freq[c] += 1
        if freq[c] < 2:
            print(c)

for w in sorted(freq, key=freq.get, reverse=False):
    print(w, freq[w])


