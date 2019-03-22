fp = [ x**5 for x in range(10) ]
tot = 0
for n in range(10, 1000000):
    ds = list(str(n))
    s = sum([ fp[int(d)] for d in ds])
    if int(s) == n:
        print(n, s)
        tot += n
print(tot)


