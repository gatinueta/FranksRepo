import fileinput

def add(p, d):
    return (p[0] + d[0], p[1] + d[1])

def get(p):
    if 0 <= p[1] < len(m) and 0 <= p[0] < len(m[p[1]]):
        return m[p[1]][p[0]]
    else:
        return None

def test(p, dirs):
    for dir in dirs:
        if get(add(p, dir)) not in (' ', None):
            return dir
    return None

m = list()
for line in fileinput.input():
    line = line.rstrip('\n')
    m.append(line)

x = m[0].index('|')
p = (x, 0)

dir = (0, 1)

string = ''
steps = 0

while(True):
    p = add(p, dir)
    steps += 1
    c = get(p)
    print(p, c)
    if c == '+':
        if dir[1] != 0:
            dir = test(p, [(1,0),(-1,0)])
        else:
            dir = test(p, [(0,1),(0,-1)])

        if dir == None:
            print('stop at ', p)
            break
    elif c.isalpha():
        string += c
    elif c not in ('|', '-'):
        print('error at ', p, ': ', c)
        break

print(string)
print(steps)
