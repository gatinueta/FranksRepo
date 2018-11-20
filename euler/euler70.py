import pickle
import os.path

MAX = 10000000
#MAX = 100

divisors = [set() for i in range(MAX) ]
for n in range(2,MAX):
    if len(divisors[n]) == 0:
        for i in range(n, MAX, n):
            divisors[i].add(n)

#for i in range(len(divisors)):
#    print('{}: {}'.format(i, divisors[i]))

def isperm(x, y):
    return sorted(str(x)) == sorted(str(y))

def phi(n):
    if len(divisors[n]) <= 2:
        res = n-1
        firstDivisor = 0
        for d in divisors[n]:
            res -= (n-1)/d
            if firstDivisor !=  0:
                res += (n-1)/(firstDivisor*d)
            else:
                firstDivisor = d
        return res
    res = 0
    for i in range(1,n):
        l = list(divisors[n])
        if len(l) == 1:
            if l[0] not in divisors[i]:
                res += 1
        elif len(l) == 2:
            if l[0] not in divisors[i] and l[1] not in divisors[i]:
                res += 1
        else:
            if len(divisors[n].intersection(divisors[i])) == 0:
                res += 1
    return res

print(phi(9))
print(phi(87109))

minratio = 10

for i in range(2,MAX):
    if len(divisors[i]) < 3:
        p = phi(i)
        if isperm(i, p):
            ratio = float(i)/p
            print('isperm: {}: {} (ratio {})'.format(i, p, float(i)/p))
            if ratio < minratio:
                print('MINRATIO!')
                minratio = ratio

