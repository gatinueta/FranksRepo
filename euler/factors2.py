import itertools
import sys

m = int(sys.argv[1])
def prime_factors(n):
    for i in itertools.chain([2], itertools.count(3, 2)):
      if n <= 1:
        break
      while n % i == 0:
        n //= i
        yield i

def getdivs(a):
    divs = 1
    n = 0
    last = 0
    for i in prime_factors(a):
        if i==last:
            n += 1
        else:
            divs *= n+1
            last = i
            n = 1
    divs *= n+1
    return divs

n = 1
t = 0
lastdivs = 0
for i in range(m):
    t = t + n
    divs = getdivs(t)
    if divs > lastdivs:
        print (t, divs)
        lastdivs = divs
    n += 1

