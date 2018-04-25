class C:
    def __contains__(self, other):
        return True
    def __iter__(self):
        for x in range(3):
            yield x

c = C()
if 10 in c:
    print('yes')

for i in c:
    print(i)
