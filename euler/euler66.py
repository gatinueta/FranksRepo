import math

LIMIT = 10000000

square = {}

def issquare(xS):
    if square.get(xS) is not None:
        return square[xS]
    x = int(math.sqrt(xS)+.5)
    square[xS] = x*x == xS
    return square[xS]
        
def findmin(D):
    for y in range(1, LIMIT):
        xS = D*y*y+1
        if issquare(xS):
            return xS
    return None

maxM = 0
maxD = None
for D in range(1000):
    Dr = int(math.sqrt(D)+.5)
    if Dr*Dr != D:
        m = findmin(D)
        print(D, m)
        if m is None:
            print(D, ' no solutions')
        elif m > maxM:
            maxD = D
            maxM = m
            print('max: ', maxD, maxM)
print(maxD, maxM)

