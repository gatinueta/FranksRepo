import sys
import math
from collections import defaultdict

if len(sys.argv) > 1:
	n = int(sys.argv[1])
else:
	n = 667


def ord(b, n):
	i = 0
	bb = 1

	if b==1:
		return 0
	if math.gcd(n,b) > 1:
		return float('inf');
	while True:
		i += 1
		bb *= b
		bb %= n
		if bb == 1:
			return i

def factorization(n):    # (cf. https://stackoverflow.com/a/15703327/849891)
    j = 2
    while n > 1:
        for i in range(j, int(math.sqrt(n+0.05)) + 1):
            if n % i == 0:
                n /= i 
                j = i
                yield i
                break
        else:
            if n > 1:
                yield int(n)
                break

def factors(n):
	return list(factorization(n))

def factormap(n):
	factorMap = defaultdict(int)
	for i in factors(n):
		factorMap[i] += 1
	return factorMap
	
def phi(n):
	if n == float('inf'):
		return n
	res = 1
	factorMap = factormap(n)
	for (k,v) in factorMap.items():
		res *= (k**v - k**(v-1))
	return res
		
def lcm(a, b):
	return a*b // math.gcd(a, b)

def clambda(n):
	if n == float('inf'):
		return n
	res = 1
	factorMap = factormap(n)
	for (k,v) in factorMap.items():
		if k == 2 and v > 2:
			res = lcm(res, phi(k**v) // 2)
		else:
			res = lcm(res, phi(k**v))
	return res

counts = defaultdict(int)
maxr = 0
for nn in range(2, n):
	r = ord(nn,n)
	counts[r] += 1
	if r > maxr:
		maxr = r
		maxnn = nn
	print('ord({},{}) == {} (factors={}, phi={})'.format(nn, n, r, factors(nn), phi(nn)))

print('factors({}) = {}, phi({}) = {}, phi(phi({})) = {}, clambda({}) = {}'.format(n, factormap(n), n, phi(n), n, phi(phi(n)), n, clambda(n)))
print('maxord:{}, smallest el maxord:{}'.format(maxr, maxnn))

for k in sorted(counts.keys()):
	print('ord {}: {} elements, phi({}) = {}, clambda({}) = {}'.format(k, counts[k], k, phi(k), k, clambda(k)))

np = 1
p = maxnn

while True:
	print('{} ** {}: {} (ord {}). gcd({},{}) = {}'.format(maxnn, np, p, ord(p, n), np, n-1, math.gcd(np, n-1)))
	if p == 1 or np > n:
		break
	np += 1
	p = (p * maxnn) % n
	
