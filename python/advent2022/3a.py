import fileinput

def prio(c):
	oc = ord(c)
	if oc > ord('a'):
		return oc - ord('a') + 1
	return oc - ord('A') + 27

sum = 0

for line in fileinput.input():
	line = line.rstrip()
	mid = int(len(line)/2)
	left = line[:mid]
	right = line[mid:]
	for c in set(left):
		if right.find(c) >= 0:
			print(c, left, right, prio(c))
			sum += prio(c)

print(sum)
	

