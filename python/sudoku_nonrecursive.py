import random
from bs4 import BeautifulSoup

board = [
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

board2 = [
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

def solve_nonrecursive(b, stack):
    while True:
        p = findempty(b)
        if p is None:
            printBoard(b)
            poss = []
#            return True
        else:
            poss = list(findPoss(b, p))
        if len(poss) > 0:
            random.shuffle(poss)
            stack.append(StackElem(p, poss, 0))
        else:
            while(True):
                if len(stack) == 0:
                    return;
                e = stack.pop()
                b[e.p.y][e.p.x] = ' '
                if e.pi < len(e.poss)-1:
                    break

            e.pi += 1
            stack.append(e)
        print_stack(stack)
        e = stack[-1]
        b[e.p.y][e.p.x] = e.poss[e.pi]


solve_nonrecursive(board, [])
exit()

def solve(b):
    p = findempty(b)
    if p is None:
        printBoard(b)
        return True
    poss = list(findPoss(b, p))
    random.shuffle(poss)
    for e in poss:
        b[p.y][p.x] = e
        #print(str(p.y) + ' is now ' + str(b[p.y]))
        if solve(b):
            return True

    b[p.y][p.x] = ' '
    return False

def create():
    row =  [' '] * 9;
    b = [ list(row) for i in range(9) ]
    solve(b)

def printBoardHtml(b, filename):
    html_doc = open('sudoku-board.html', 'r')
    soup = BeautifulSoup(html_doc, 'html.parser')
    for cellid in range(81):
        col = cellid % 9
        row = cellid / 9;
        tag = soup.find(id='cell-{}'.format(cellid))
        tag['value'] = b[row][col]
        if riddle_board[row][col] == ' ':
            del tag['disabled']
        else:
            tag['disabled'] = ''
    f = open(filename, 'w')
    f.write(soup.prettify())
    f.close()
    
printBoardHtml(board, 'sudoku-board-riddle.html')

if solve(board):
    printBoardHtml(board, 'sudoku-board-solution.html')


#create()
