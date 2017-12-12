import fileinput

l = []

for line in fileinput.input():
	l.append(int(line))
	
print(l)

i = 0
steps = 0

while 0 <= i and i < len(l):
	nexti = l[i]
	if nexti >= 3:
		l[i] -= 1
	else:
		l[i] += 1
	steps += 1
	i += nexti

print(steps)	