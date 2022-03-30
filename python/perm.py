class Perm: 
	def __init__(self, n, lol):
		self.n = n
		self.l = self._tol(lol)
		self._tocycles()
		
	def _tol(self, lol):
		rl = list(range(self.n+1))
		wlol = list(lol)
		while len(wlol) > 0:
			el = wlol.pop()
			rr = list(rl)
			for i in range(len(el)):
				source = el[i]
				dest = el[(i+1)%len(el)]
				sp = rl.index(source)
				tp = rl.index(dest)
				rr[tp] = source
			rl = rr
		return rl
	
	def _tocycles(self):
		self.cycles = []
		tlist = list(range(1, self.n+1))
		while len(tlist)>0:
			cycle = []
			el = tlist.pop(0)
			cycle.append(el)
			pos = self.l.index(el)
			while pos != cycle[0]:
				el = tlist.pop(tlist.index(pos))
				cycle.append(el)
				pos = self.l.index(el)
			self.cycles.append(cycle)

	def printl(self):
		print('function:')
		print(range(1, self.n+1))
		print(self.l[1:])

	def printc(self):
		print('cycles:')
		for cycle in self.cycles:
			print(cycle)
		
	def __mul__(self, p):
		newP = Perm(self.n, self.cycles + p.cycles);
		return newP;

	def __eq__(self, p):
		return self.l == p.l;

c = ([1,2], [3,4])
p = Perm(4, c)

p.printl()
p.printc()

c2 = ([1,4],[1,3])
p2 = Perm(4, c2)

p2.printl()
p2.printc()

p = p * p2

p.printl()
p.printc()

c3 = ([1,2,3],)

p3 = Perm(4, c3)
p4 = Perm(4, c3)
print('3 times ', c3, ':')
for i in range(3):
	p3.printl()
	p3.printc()
	p3 = p3 * p4


c5 = ([1,2,3,4],)

p6 = Perm(4, c5)

ip = Perm(4, ())
p5 = ip

print ('rotation:')
for i in range(5):
	p5.printl()
	p5.printc()
	if p5 == ip:
		print('is identity')
	p5 = p5 * p6

