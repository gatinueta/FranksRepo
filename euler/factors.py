import sys
from collections import defaultdict
to = int(sys.argv[1])
thres = int(sys.argv[2])
#factors = defaultdict(list)
isprime = defaultdict(bool)
nofdivs = defaultdict(lambda : 1)
for i in range(2, to):
    if nofdivs[i] == 1:
        for m in range(2*i, to, i):
            ex = 1
            d = m/i
            while d%i == 0:
                ex += 1
                d /= i
            #factors[m].append([i, ex])
            nofdivs[m] *= ex+1

i = 1
n = 1
while n<to:
    if nofdivs[n] > thres:
        print(n, nofdivs[n])
    i += 1
    n += i

print(nofdivs)

