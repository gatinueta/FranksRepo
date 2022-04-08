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

def phi(n):
	factorMap = defaultdict(int)
	for i in factors(n):
		factorMap[i] += 1
	res = 1
	for (k,v) in factorMap.items():
		res *= (k**v - k**(v-1))
	return res
		
counts = defaultdict(int)

for nn in range(1, n+1):
	r = ord(nn,n)
	counts[r] += 1

	print('ord({},{}) == {} (factors={}, phi={})'.format(nn, n, r, factors(nn), phi(nn)))

print(counts)

