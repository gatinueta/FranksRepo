from math import sin

def printme(a,b,c):
    print a, b, c

def f(func, args):
    return func(*args)

print f(printme, ['a', 1, 100]);


