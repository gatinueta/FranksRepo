MAX=1000001
s= [False, False] + ([ True ] * MAX)

def trunc(n, left):
    while True:
        if not s[n]:
            return False
        if n<10:
            return True
        if left:
            n = int(str(n)[1:])
        else:
            n = int(str(n)[:-1])
    return True

for n in range(2, MAX):
    if s[n]:
        m=2
        while n*m < MAX:
            s[n*m] = False 
            m += 1

sum=0
for n in range(11, MAX):
    if trunc(n, True) and trunc(n, False):
        sum += n

print sum

