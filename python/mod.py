import sys

if len(sys.argv) > 1:
	n = int(sys.argv[1])
else:
	n = 667

i = 0
b = 1


while(True):
	i += 1
	b *= 10
	r = b % n
	if r>n/2:
		r -= n 
	print(i, r);
	if r==1:
		break
