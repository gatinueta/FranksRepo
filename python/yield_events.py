def f1():
    for i in range(3):
        print(i*2)

def f2():
    for i in range(10):
        yield i*2

f1()

import fileinput

g = f2()
for i in fileinput.input():
    print(next(g))


