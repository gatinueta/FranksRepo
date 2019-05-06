from math import sqrt, floor
MAX = 100000000
count = 0
for sc in range(MAX):
    if sc % (MAX/100) == 0:
        print(sc/(MAX/100))
    for s in range(1,sc/2+1):
        t = sc - s
        ls = s*s + t*t
        l = int(floor(sqrt(ls)+.5))
        if s + t + l < MAX and l*l == ls:
            #print(s, t, l)
            if l%(t-s) == 0:
               count += 1
print(count)


