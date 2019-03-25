import re

class Group:
    def __init__(self, i):
        self.string = i[0]
        self.correct = int(i[1])
    def __str__(self):
        return "string={}, correct={}".format(self.string, self.correct)

prob = '''5616185650518293 ;2 correct
3847439647293047 ;1 correct
5855462940810587 ;3 correct
9742855507068353 ;3 correct
4296849643607543 ;3 correct
3174248439465858 ;1 correct
4513559094146117 ;2 correct
7890971548908067 ;3 correct
8157356344118483 ;1 correct
2615250744386899 ;2 correct
8690095851526254 ;3 correct
6375711915077050 ;1 correct
6913859173121360 ;1 correct
6442889055042768 ;2 correct
2321386104303845 ;0 correct
2326509471271448 ;2 correct
5251583379644322 ;2 correct
1748270476758276 ;3 correct
4895722652190306 ;1 correct
3041631117224635 ;3 correct
1841236454324589 ;3 correct
2659862637316867 ;2 correct'''

lines = prob.split('\n')

matches = []
for line in lines:
    m = re.match(r'(\d+) ;(\d+) correct', line)
    matches.append(Group(m.groups()))

matches.sort(key = lambda m: m.correct)
print('\n'.join([str(m) for m in matches]))

LEN = 16
ng = [ [] for i in range(LEN) ]

def find(ng, mi, sel):
    if mi >= len(matches):
        print('fail')
        return
    if sel is None:
        sel = list(range(matches[mi].correct))
    else:
        le = len(sel)-1
        max = LEN-1
        while le >= 0 and sel[le] == max:
            le -= 1
            max -= 1
        if le < 0:
            mi += 1
            sel = list(range(matches[mi].correct))
        else:
            b = sel[le] + 1
            for i in range(le, len(sel)):
                sel[i] = b
                b += 1
    for i in sel:
        ng[i].append(matches[mi].string[i])
    print(ng, mi, sel)
    find(ng, mi, sel)
    for i in sel:
        ng[i].pop()

            

find(ng, 0, None)

