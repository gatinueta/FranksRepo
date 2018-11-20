from itertools import product
LIMIT = 28123+1

d = [ 0 ] * LIMIT

for n in range(2,LIMIT):
    for m in range(1, LIMIT/n):
        d[m*n] += m

ab = [ n for n in range(1,LIMIT) if n<d[n] ]
absum= [False] * LIMIT
for pair in product(ab, ab):
    psum=sum(pair)
    if psum<LIMIT:
        absum[psum] = True

print sum([ n for n in range(1,LIMIT) if not absum[n] ])




