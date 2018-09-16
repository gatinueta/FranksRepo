board = [
      '5   32  8',
      '   8  4  ',
      ' 73   5  ',
      '2     89 ',
      '6       4',
      ' 49     3',
      '  5   37 ',
      '  6  7   ',
      '7  96   5' 
]

for rownum in range(len(board)):
    board[rownum] = list(board[rownum])

class Coord:
    def __init__(self, x, y):
        self.x = x
        self.y = y
    def __str__(self):
        return '({},{})'.format(self.x, self.y)

def findempty(b):
    for rownum in range(len(b)):
        row = b[rownum]
        try:
            index = row.index(' ')
            return Coord(index, rownum)
        except ValueError:
            pass
    return None
    
INDEX = ' |012|345|678| '

def printBoard(b):
    print(INDEX)    
    print( '-' * 14)
    for rownum in range(len(b)):
        row = b[rownum]
        l = str(rownum) + '|'
        for g in range(3):
            for e in range(3):
                l += row[g*3+e]
            l += '|'
        print(l)
        if rownum%3 == 2:
            print('-' * 14)
    print( '-' * 14)

printBoard(board)

def findPoss(b, p):
    sx = p.x - (p.x % 3)
    sy = p.y - (p.y % 3)

    s = set(map(str, range(1,10)))
    for xi in range(3):
        for yi in range(3):
            s.discard(b[sy+yi][sx+xi])

    for xi in range(9):
        s.discard(b[p.y][xi])

    for yi in range(9):
        s.discard(b[yi][p.x])

    return s

    
def solve(b):
    p = findempty(b)
    if p is None:
        printBoard(b)
        return True
    poss = findPoss(b, p)
    for e in poss:
        b[p.y][p.x] = e
        #print(str(p.y) + ' is now ' + str(b[p.y]))
        if solve(b):
            return True

    b[p.y][p.x] = ' '
    return False

solve(board)

