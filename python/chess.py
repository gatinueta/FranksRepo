class Board:
    def __init__(self):
        self.b = [ [None] * 8 for i in range(8) ]
    def set(self, c, piece):
        self.b[c.col][c.row] = piece
    def __str__(self):
        s = ''
        for col in self.b:
            for row in col:
                s += str(self.b[col][row])
            s += "\n"
        return s

b = Board()
print(str(b))



