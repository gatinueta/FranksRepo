import fileinput

values = {
	'0': 0,
	'1': 1,
	'2': 2,
	'-': -1,
	'=': -2
}

inv_values = {v: k for k, v in values.items()}

def snafu2dec(n):
	v = 1
	value = 0
	for c in n[::-1]:
		value = value + values[c]*v
		v *= 5
	return value

def dec2snafu(n):
	v = 5
	res = ''
	while n > 0:
		p = n%5
		if p > 2: 
			p -= 5
		res = inv_values[p] + res
		n -= p
		n /= 5
	return res

tot = 0
	
for line in fileinput.input():
	snafunum = line.strip()
	if len(snafunum) > 0:
		dec = snafu2dec(snafunum)
		print(dec)
		tot += dec

print(dec2snafu(tot))


#print(dec2snafu(3))
#print(dec2snafu(314159265))

