import fileinput
import re

m = [
    '.#.',
    '..#',
    '###'
]

#m = [ '123', '456', '789' ]

def flip(m):
    mf = []
    for line in m:
        mf.append(''.join(reversed(line)))
    return mf

def rotate(m):
    s = len(m[0])
    mr = []
    for i in range(s):
        mr.append(''.join([ m[j][i] for j in reversed(range(s))]))
    return mr

def getvars(m):
    mf = flip(m)
    var = []
    for i in range(4):
        var.append(m)
        m = rotate(m)
        mf = rotate(mf)
        var.append(mf)

    return var

rules = []
for line in fileinput.input():
    mr = re.match('(\\S+) => (\\S+)', line)
    if mr:
        instr, outstr = mr.groups()
        ons = instr.count('#')
        inm = instr.split('/')
        outm = outstr.split('/')
        rules.append((ons, inm, outm))
    else: 
        print(line, ': no match')

def split(m):
    s = len(m[0])

    if s%2 == 0:
        d = 2
    else:
        d = 3

    blocks = []
    for y in range(int(s/d)):
        blockline = []
        for x in range(int(s/d)):
            block = []
            for yd in range(d):
                block.append(''.join([m[y+yd][x+xd] for xd in range(d)]))
            blockline.append(block)
        blocks.append(blockline)
    return blocks

def join(blocks):
    s = len(blocks)
    bs = len(blocks[0][0])
    m = [ [] for i in range(s*bs)]
    for y in range(s):
        for yi in range(bs):
            for x in range(s):
                for xi in range(bs):
                    m[y*bs+yi].append(blocks[y][x][yi][xi])
    for y in range(len(m)):
        m[y] = ''.join(m[y])
    return m
    
            
def countons(m):
    n = 0
    for line in m:
        n += line.count('#')
    return n

def printm(m):
    for line in m:
        print(line)

it = 0
while True:
    blocks = split(m)

    nb = len(blocks)

    for y in range(nb):
        for x in range(nb):
            ons = countons(blocks[y][x])
            vars = getvars(blocks[y][x])
            found_rule = False
            for var in vars:
                for rule in rules:
                    if ons == rule[0] and rule[1] == var:
                        blocks[y][x] = rule[2]
                        found_rule = True
                        break
                if found_rule:
                    break
            if not found_rule:
                print('error: no rule found')
                    
    print(blocks)
    m = join(blocks)
    it += 1
    printm(m)
    print('-----')
    if it == 6:
        print(countons(m))
        break
