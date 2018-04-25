class E:
    pass

class A:
    def __init__(self, x):
        self.x = x
    def __add__(self,other):
        return A(self.x + other.x)
    def __str__(self):
        return "A({})".format(self.x)


a = A(100)
b = A(20)

a += b

print(a)
print(b)

e = E()
e.x = 12

a += e

print(a)

e = E()

a += e

