from math import sqrt

def sieve_factors(n):
    factors = [ [] for i in range(n) ]
    for i in range(2, n):
        if len(factors[i]) == 0:
            j=1
            while i*j < n:
                m=1
                f = j
                while f % i == 0:
                    m += 1 
                    f /= i
                factors[i*j].append('{}^{}'.format(i,m))
                j += 1
    return factors

factors = sieve_factors(1000)

class Rational:
    def __init__(self, nom, denom):
        self.nom = nom
        self.denom = denom

    def normalize(self):
        found = True
        while found:
            fn = factors[self.nom]
            fd = factors[self.denom]
            found = False
            for f in fn:
                if f in fd:
                    self.nom /= f
                    self.denom /= f
                    found = True
                    break

    def __str__(self):
        return '{} / {}'.format(self.nom, self.denom)


r = Rational(10, 12)

print(r)
r.normalize()
print(r)

for i in range(len(factors)):
    print(i, factors[i])
