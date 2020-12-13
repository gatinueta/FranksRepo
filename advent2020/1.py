import fileinput
arr = []
with fileinput.input(files=('1.txt')) as f:
    for line in f:
        arr.append(int(line))

print (arr)

for i1 in arr:
    for i2 in arr:
        for i3 in arr:
            if i3 >= i2 >= i1:
                if i1 + i2 + i3 == 2020:
                    print (i1, i2, i3, i1*i2*i3);