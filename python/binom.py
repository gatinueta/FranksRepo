s = str(1001**8)
for i in range(len(s)%3-3, len(s), 3):
	print(int(s[max(0,i):i+3]))
print()

l = 4
n = 10

s = str((10**l + 1)**n)

for i in range(len(s)%l-l, len(s), l):
	sb = max(0,i)
	se = i+l
	print(int(s[sb:se]))


