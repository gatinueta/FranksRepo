import fileinput
import re

l = []
maxweight = 0

def printsol(li):
    w = 0
    for i,v in enumerate(li):
        it = l[v[0]]
        print(i, it, v[1])
        w += it[0] + it[1]
    print('weight ', w)
    return w

def search(li, si):
    global maxweight
    w = printsol(li)
    if w > maxweight:
        maxweight = w
        print('maxweight is ', maxweight)

    last = li[-1]
    lastv = l[last[0]][1-last[1]]
    print('lastv is ', lastv)
    for i,v in enumerate(l):
        if i not in si:
            if v[0] == lastv or v[1] == lastv:
                mi = int(v[1] == lastv)
                si.add(i)
                li.append([i,mi])
                search(li, si)

            

for line in fileinput.input():
    m = re.match('(\\d+)/(\\d+)', line)
    comp1 = int(m.group(1))
    comp2 = int(m.group(2))
    l.append((comp1, comp2))

print(l)

for i, comp in enumerate(l):
    if comp[0] == 0 or comp[1] == 0:
        search([(i, int(comp[1]==0))], {i})


