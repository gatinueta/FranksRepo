class C:
    def __init__(self, c):
      self.c = c
    def __hash__(self):
      return self.c.__hash__()
    def __eq__(self, other):
      return self.c == other.c
    def __str__(self):
      return 'C({})'.format(self.c)

c = C('2')
c2 = C('3')

d = dict()

d[1] = 'eins'
d[c] = 'zwei'
d[c2] = 'drei'

print(d)

c2.c = '2'

print(d)

print(d[C('3')])
