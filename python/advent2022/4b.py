import fileinput
import re

overlaps = 0
for line in fileinput.input():
	m = re.match('(\\d+)-(\\d+),(\\d+)-(\\d+)', line)
	if m:
		
		s1 = set(range(int(m.group(1)), int(m.group(2))+1))
		s2 = set(range(int(m.group(3)), int(m.group(4))+1))
		if len(s1.intersection(s2)) > 0:
			overlaps += 1

print(overlaps)
