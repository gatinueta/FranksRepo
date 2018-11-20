SIZE = 8

class Field:
    def __init__(self, x, y):
        self.x = x
        self.y = y
    def add(self, t):
        return Field(self.x + t[0], self.y + t[1])
    def inbounds(self):
        return 0 <= self.x < SIZE and 0 <= self.y < SIZE
    def __str__(self):
        return "({},{})".format(self.x, self.y)

MOVES = ((+1,+2), (+2,+1), (-1,+2), (+2,-1), (-1,-2), (-2,-1), (-2,+1), (+1,-2))

def moves(p):
    res = []
    for move in MOVES:
        mp = p.add(move)
        if mp.inbounds():
            res.append(mp)
    return res

ms = moves(Field(0, 0))
for m in ms:
    print(str(m))

