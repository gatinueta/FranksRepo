import fileinput

def reverse_sublist(l, p, length):
    sl = []
    for i in reversed(range(length)):
        sl.append(l[(p+i)%len(l)])
    return sl

def set_sublist(l, p, sl):
    for i in range(len(sl)):
        l[(p+i)%len(l)] = sl[i]

for line in fileinput.input():
    lengths = [int(t) for t in line.split(',')]

l = list(range(256))

curpos = 0
skip_size = 0

for length in lengths:
    print (length, curpos, skip_size)
    sl = reverse_sublist(l, curpos, length)
    set_sublist(l, curpos, sl)
    print(l)
    curpos = (curpos + length + skip_size) % len(l)
    skip_size += 1

print(l[0]*l[1])


