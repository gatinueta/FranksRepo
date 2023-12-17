import fileinput
import re
from functools import reduce

maxcubes = { 'red': 12, 'green': 13, 'blue': 14 }

def process1(gameno, result):
    results = result.split(';')
    for r in results:
        colorres = r.split(',')
        for res in colorres:
            m = re.search('(\\d+) (\\w+)', res)
            (n, color) = (int(m.group(1)), m.group(2))
            if maxcubes[color] < n:
                print(f'reject: game {gameno}: {n} {color}')
                return False
    return True
            
def process2(gameno, result):
    mincubes = { 'red': 0, 'green': 0, 'blue': 0 }
    results = result.split(';')
    for r in results:
        colorres = r.split(',')
        for res in colorres:
            m = re.search('(\\d+) (\\w+)', res)
            (n, color) = (int(m.group(1)), m.group(2))   
            if mincubes[color] < n:
                mincubes[color] = n
    print(f'{gameno}: {mincubes}')
    return reduce(lambda x,y: x*y, mincubes.values(), 1)
 
(total, total2) = (0, 0)

for line in fileinput.input(encoding="utf-8"):
    if match := re.search('Game (\\d+): (.*)', line):
        (gameno, result) = (int(match.group(1)), match.group(2))
        if process1(gameno, result):
            total += gameno
        total2 += process2(gameno, result)

print(total)

print(total2)
        
    

