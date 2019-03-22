from math import sqrt

def factors(n):
    d = []
    for i in range(1, int(sqrt(n))+1):
        if n % i == 0:
            d.append(i)
            if n/i != i:
                d.append(n/i)
    return d

for n in range(100):
    print(n, factors(n))

