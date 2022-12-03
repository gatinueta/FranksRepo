import fileinput

def prio(c):
	oc = ord(c)
	if oc > ord('a'):
		return oc - ord('a') + 1
	return oc - ord('A') + 27

sum = 0
lines = [ line.rstrip() for line in fileinput.input() if len(line)>2 ]

for i in range(0, len(lines), 3):
	s = None
	for r in lines[i:i+3]:
		if s is None:
			s = set(r)
		else:
			s.intersection_update(set(r))
	print(s)
	sum += prio(s.pop())

print(sum)

	


	

