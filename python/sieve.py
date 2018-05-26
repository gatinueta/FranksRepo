from math import sqrt
MAX = 101
p = [True] * MAX

for i in range(2,int(sqrt(MAX))+1):
    if p[i]:
        for j in range(i*2, MAX, i):
            p[j] = False

primes = [i for i in range(2,MAX) if p[i]]
print(primes)

res = 1
for i in range(2,MAX):
    if p[i]:
        res *= i

print(res) 
