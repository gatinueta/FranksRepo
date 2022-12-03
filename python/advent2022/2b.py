import fileinput

# 1 Stein
# 2 Papier
# 3 Schere

beats = { 
	1: 3,
	2: 1,
	3: 2
} 

loses = {v: k for k, v in beats.items()}

totpkt = 0
for line in fileinput.input():
	if len(line) > 2:
		op = ord(line[0]) - ord('A')+1
		ps = line[2]
		if ps == 'X':
			pp = beats[op]
		elif ps == 'Y':
			pp = op
		else:
			pp = loses[op]
			
		if beats[pp] == op:
			pkt = 6
		elif pp == op:
			pkt = 3
		elif beats[op] == pp:
			pkt = 0
		pkt += pp
		print(line, op, pp, pkt)
		totpkt += pkt

print(totpkt)

