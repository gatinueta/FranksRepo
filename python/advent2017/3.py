
c = (0, 0)
mv = ((+1, 0), (0, +1), (-1, 0), (0, -1))

g = []
h = {}

def draw(h):
	LEN = 10
	m = [[0 for x in range(2*LEN+1)] for y in range(2*LEN+1)]

	for key, value in h.items():
		if abs(key[0]) < LEN and abs(key[1]) < LEN:
			m[-key[1] + LEN][key[0] + LEN] = str(value)
			
	for line in m:
		print(' '.join([ '{0:>4}'.format(i) for i in line]))
			
	
	
def add(a, b):
	return (a[0]+b[0], a[1]+b[1])
	
def visit(p, val):
	g.append(p)
	h[p] = val

def visited(p):
	res = p in h
	return res

def getval(c):
	if c == (0,0):
		return 1
	sum = 0
	for x in (-1, 0, 1):
		for y in (-1, 0, 1):
			if x != 0 or y != 0: 
				val = h.get(add(c, (x,y)))
				sum += val or 0	
	if sum > 347991:
		print('first is ', sum)
	return sum
					
i = 3
ni = (i+1)%4

for x in range(1, 100):
	visit(c, getval(c))
	if not visited(add(c, mv[ni])):
		i = ni
		ni = (i+1)%4
	c = add(c, mv[i])
	
print(g)
print(h)
draw(h)
