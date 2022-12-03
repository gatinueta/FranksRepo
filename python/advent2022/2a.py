import fileinput

# 1 Stein
# 2 Papier
# 3 Schere

beats = { 
	1: 3,
	2: 1,
	3: 2
} 

totpkt = 0
for line in fileinput.input():
	if len(line) > 2:
		op = ord(line[0]) - ord('A')+1
		pp = ord(line[2]) - ord('X')+1
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

