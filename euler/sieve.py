import sys
from math import sqrt;

from itertools import combinations, permutations

def sieve(n):
    isprime = [ True for i in range(n) ];

    isprime[0] = False
    isprime[1] = False
    for i in range(2, int(sqrt(n))):
        if isprime[i]:
            f = 2
            while f*i < n:
                isprime[f*i] = False
                f += 1

    return isprime;

if len(sys.argv) > 1:
    max = int(sys.argv[1])
    primes = sieve(max)

#for l in range(1, 9):
#    for c in combinations(range(1, 10), l):
#        for p in permutations(c):
#            n = int(''.join([str(e) for e in p]))
#            if len(primes) >= n and primes[n]:
#                print(n)

#euler41
def euler41():
    # not more than 7 digits
    primes = sieve(10000000)
    for n in range(2, 11):
        for p in permutations(range(1, n)):
            n = int(''.join([str(e) for e in p]))
            if len(primes) >= n and primes[n]:
                print(n)

def sortn(n):
    l = list(str(n))
    l.sort()
    return l

def euler49():
    primes = sieve(10000)
    for i in range(10000-2*3330):
        if primes[i] and primes[i+3330] and primes[i+2*3330]:
            if sortn(i) == sortn(i+3330) == sortn(i+2*3330):
                print(i, i+3330, i+2*3330)

print(sortn(124240))
euler49();
