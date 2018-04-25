p = [True] * 101

for i in range(2,10):
    for j in range(i*2, 101, i):
        p[j] = False

res = 1
for i in range(2,101):
    if p[i]:
        res *= i
        print(i)

print(res) 
