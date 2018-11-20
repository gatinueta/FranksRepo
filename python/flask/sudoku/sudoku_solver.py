import random
import sys

board1 = [
    ' 7 25 4  ',
    '8     9 3',
    '     3 7 ',
    '7    4 2 ',
    '1       7',
    ' 4 5    8',
    ' 9 6     ',
    '4 1     5',
    '  7 82 3 '
]

board2 = [
    '9     34 ',
    ' 51943  6',
    '47 65 8  ',
    '     14  ',
    ' 19 6  3 ',
    '7  8951  ',
    '  2    87',
    '5687 4  3',
    ' 9   62 4'
]

board3 = [
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

boards = [ board1, board2, board3 ]

boardno = 0

board = boards[ boardno ]

riddle_board = []
for rownum in range(len(board)):
    board[rownum] = list(board[rownum])
    riddle_board.append(list(board[rownum]))

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
            colnum = row.index(' ')
            return Coord(colnum, rownum)
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

class StackElem:
    def __init__(self, p, poss, pi):
        self.p = p
        self.poss = poss
        self.pi = pi
    def __str__(self):
        return "p = {}, poss = {}, pi = {}".format( self.p, self.poss, self.pi)

def print_stack(stack):
    for i in stack:
        print(str(i))
    print()

def solve_nonrecursive(b, stack, stopIfFound, doYield=False):
    while True:
        if doYield:
            yield b
        # check if a solution has been found. print it.
        # find options to advance, store into poss array.
        # push these options on the stack.
        # if no options can be found, backtrack, i.e. pop
        # from stack as long as there are more options..
        # advance to the next option.
        p = findempty(b)
        if p is None:
            #printBoard(b)
            print('found solution')
            poss = []
            if stopIfFound:
                return
        else:
            poss = list(findPoss(b, p))
        if len(poss) > 0:
            random.shuffle(poss)
            stack.append(StackElem(p, poss, 0))
        else:
            while(True):
                if len(stack) == 0:
                    # we're done. there's no (more) solutions.
                    print('no (more) solution')
                    return
                e = stack.pop()
                b[e.p.y][e.p.x] = ' '
                if e.pi < len(e.poss)-1:
                    break

            e.pi += 1
            stack.append(e)
        # now the last stack element contains the next option to be investigated.
        # apply it to the board.
        #print_stack(stack)
        e = stack[-1]
        b[e.p.y][e.p.x] = e.poss[e.pi]

def create():
    row =  [' '] * 9;
    b = [ list(row) for i in range(9) ]
    solve(b)

g = None

def solve_rest():
    solve_nonrecursive(board, [], True)
    return board

def solve_next():
    global g
    if g is None:
        g = solve_nonrecursive(board, [], True, True)
    return next(g)

#while(True):
#    b = solve_next()
#    printBoard(b)

#create()
