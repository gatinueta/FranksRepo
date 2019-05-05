from math import factorial
fp = [ factorial(x) for x in range(10) ]
print(fp)
tot = 0
for n in range(10, 10000000):
    ds = list(str(n))
    s = sum([ fp[int(d)] for d in ds])
    if int(s) == n:
        print(n, s)
        tot += n
print(tot)


