import fileinput
from collections import deque 
from collections import defaultdict

q = deque()
histo = defaultdict(int)
nof_overruns = 0 

def incr_histo(c):
    global nof_overruns
    if histo[c] == 1:
        nof_overruns += 1
    histo[c] += 1
    
def decr_histo(c):
    global nof_overruns
    histo[c] -= 1
    if histo[c] == 1:
        nof_overruns -= 1


def init():
    global nof_overruns
    nof_overruns = 0
    q.clear()
    histo.clear()
    incr_histo(' ')
    for i in range(14):
        q.append(' ')
        incr_histo(' ')

for line in fileinput.input():
    init()
    found_solution = False
    for charno, c in enumerate(line):
        q.append(c)
        r = q.popleft()
        decr_histo(r)
        incr_histo(c)

        #print(charno, q, histo, nof_overruns)
        if nof_overruns == 0 and not found_solution:
            print(f'Solution: {charno+1}')
            found_solution = True


