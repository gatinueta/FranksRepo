import fileinput
import re

m = [
    '.#.',
    '..#',
    '###'
]

def flip(m):
    mf = []
    for line in m:
        mf.append(''.join(reversed(line)))
    return mf

def rotate(m):
    s = len(m[0])
    mr = []
    for i in range(s):
        mr.append(''.join([ m[j][i] for j in range(s)]))
    return mr

def var(m):
    mf = flip(m)
    var = []
    for i in range(4):
        m = rotate(m)
        mf = rotate(mf)
        var.append(m)
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

def countons(m):
    n = 0
    for line in m:
        n += line.count('#')
    return n

blocks = split(m)

nb = len(blocks)

for y in range(nb):
    for x in range(nb):
        ons = countons(blocks[y][x])
        vars = var(blocks[y][x])
        found_rule = False
        for var in vars:
            for rule in rules:
                if ons == rule[0]:
                    print(rule[1], var)
                if rule[1] == var:
                    blocks[y][x] = rule[2]
                    found_rule = True
                    break
            if found_rule:
                break
        if not found_rule:
            print('error: no rule found')
                    
print(blocks)




