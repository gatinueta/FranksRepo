import fileinput
import re

for line in fileinput.input():
	#line = '0 2  7 0'
	l = [int(w) for w in re.split('\\s+', line)]

def redist(l):
	n = max(l)
	i = l.index(n)
	l[i] = 0
	while n>0:
		i = (i+1) % len(l)
		l[i] += 1
		n -= 1
		
c = set()
n = 0
rep = None

while True:
	t = tuple(l)
	if t in c:
		break
#	print(t)
	c.add(t)
	redist(l)
	n += 1

print(n)

rep = tuple(l)
redist(l)
ls = 1

while tuple(l) != rep:
	redist(l)
	ls += 1
	
print(ls)
	
