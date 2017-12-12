import fileinput
import re
from collections import defaultdict

valid = 0

def hist(w):
	h = defaultdict(int)
	for c in w:
		h[c] += 1
	
	return tuple(sorted(h.items()))
		
for line in fileinput.input():
	line = line.strip()
	tokens = re.split('\\s+', line)
	histograms = [ hist(w) for w in tokens ]
	if len(line) > 0 and len(histograms) > 0 and len(histograms) == len(set(histograms)):
		valid += 1
		
print(valid)
