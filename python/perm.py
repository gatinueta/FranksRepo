# use 
# python3 -m pdb perm.py
# for interactive play

from itertools import permutations

class Perm: 
	class Iter:
		def __init__(self, n):
			self.n = n

		def __iter__(self):
			self.perms = permutations(range(1, self.n+1))
			return self
		def __next__(self):
			p = next(self.perms)
			nt = (0,) + p	
			return Perm(self.n, nt, True)

	@staticmethod
	def enumerate(n):
		myiter = Perm.Iter(n)
		return iter(myiter)
	
	@staticmethod		
	def id(n):
		return Perm(n, ())
	
	def __init__(self, n, lol, asfunc=False):
		self.n = n
		if asfunc:
			self.l = tuple(lol)
		else:
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
		return tuple(rl)
	
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
		newP = Perm(self.n, p.cycles + self.cycles)
		return newP

	def inv(self):
		newP = Perm(self.n, map(lambda l: list(reversed(l)), self.cycles))
		return newP

	def __truediv__(self, p):
		return self * p.inv()

	def __pow__(self, ex):
		if ex == 0:
			return Perm(self.n, ())
		elif ex > 0:
			return self.__pow__(ex-1) * self
		else:
			return self.__pow__(ex+1) / self
		
					
	def __eq__(self, p):
		return self.l == p.l;

	def __str__(self):
		return ', '.join(map(str, self.cycles))
	def __repr__(self):
		return 'Perm({0})'.format(self.__str__())

	def __hash__(self):
		return hash((self.n, self.l))

	@staticmethod
	def cosets(subgroup):
		cosets = set()
		n = next(iter(subgroup)).n
		for operm in Perm.enumerate(n):
			cosets_operm = set()
			for perm in subgroup:
				el = operm * perm	
				cosets_operm.add(el)
			cosets.add(frozenset(cosets_operm))	
		return cosets

def example():
	c = ([1,2], [3,4])
	p = Perm(4, c)

	print(str(p))
	p.printl()

	c2 = ([1,4],[1,3])
	p2 = Perm(4, c2)

	p = p * p2

	print(str(p))

	c3 = ([1,2,3],)

	p3 = Perm(4, c3)
	p4 = Perm(4, c3)
	print('3 times ', c3, ':')
	for i in range(3):
		print(p3 ** i)


	c5 = ([1,2,3,4],)

	p6 = Perm(4, c5)

	ip = Perm(4, ())
	p5 = ip

	print ('rotation:')
	for i in range(5):
		p5.printl()
		if p5 == ip:
			print('is identity')
		p5 = p5 * p6

	pit = Perm.enumerate(3)

	for perm in pit:
		print(perm)

	subgroup = set()
	generator = Perm(4, ((1,2,3,4),))
	id = Perm(4, ())

	subgroup.add(id)
	newperm = generator
	while newperm != id:
		subgroup.add(newperm)
		newperm *= generator


	cosets = Perm.cosets(subgroup)
	print(cosets)

	fourgroup = (
		Perm(4, ()),
		Perm(4, ((1,2),(3,4))),
		Perm(4, ((1,3),(2,4))),
		Perm(4, ((1,4),(2,3)))
	)
	for coset in Perm.cosets(fourgroup):
		print(coset)


