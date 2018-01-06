import fileinput
import re

l = []
maxweight = 0
maxlength = 0

def printsol(li):
    w = 0
    length = 0
    for i,v in enumerate(li):
        it = l[v[0]]
#        print(i, it, v[1])
        w += it[0] + it[1]
        length += 1
#    print('weight ', w)
    return (w,length)

def search(li, si):
    global maxweight
    global maxlength

    last = li[-1]
    lastv = l[last[0]][1-last[1]]
    found = False
    for i,v in enumerate(l):
        if i not in si:
            if v[0] == lastv or v[1] == lastv:
                found = True
                mi = int(v[1] == lastv)
                si.add(i)
                li.append([i,mi])
                if not search(li, si):
                    w,length = printsol(li)
                    if length > maxlength or (length == maxlength and w > maxweight):
                        maxlength = length
                        maxweight = w
                        print('maxlength/weight is ', maxlength, maxweight)
                si.remove(i)
                li.pop()
    return found
            

for line in fileinput.input():
    m = re.match('(\\d+)/(\\d+)', line)
    comp1 = int(m.group(1))
    comp2 = int(m.group(2))
    l.append((comp1, comp2))

print(l)

for i, comp in enumerate(l):
    if comp[0] == 0 or comp[1] == 0:
        search([(i, int(comp[1]==0))], {i})


