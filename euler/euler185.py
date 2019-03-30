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

probtest = '''90342 ;2 correct
70794 ;0 correct
39458 ;2 correct
34109 ;1 correct
51545 ;2 correct
12531 ;1 correct'''

print '39542 [[],[0],[2],[3,4],[0,1],[2,3]]'
DEBUG = False
lines = prob.split('\n')

matches = []
for line in lines:
    m = re.match(r'(\d+) ;(\d+) correct', line)
    matches.append(Group(m.groups()))

matches.sort(key = lambda m: m.correct)
print('\n'.join([str(m) for m in matches]))

LEN = len(matches[0].string)

def nextsel(sel, mi):
    if sel is None:
        newsel = list(range(matches[mi].correct))
    else:
        newsel = list(sel)
        le = len(sel)-1
        max = LEN-1
        while le >= 0 and sel[le] == max:
            le -= 1
            max -= 1
        if le < 0:
            newsel = None
        else:
            b = sel[le] + 1
            for i in range(le, len(sel)):
                newsel[i] = b
                b += 1
    return newsel

def printl(l):
    for e in l:
        print(e)
    print('')

def checksoft(config, printSolution=False):
    solution = [ None for d in range(LEN) ]
    for i in range(len(config)):
        for pos in config[i]:
            d = matches[i].string[pos]
            if solution[pos] in (None,d):
                solution[pos] = d
            else:
                if printSolution:
                    print('fail')
                    print(config)
                    printl(solution)
                return False
    if printSolution:
        print('success')
        print(config)
        printl(solution)
    return True

def check(config, printSolution=False):
    solution = [ set([str(d) for d in range(10)]) for i in range(LEN) ]
    for i in range(len(config)):
        for pos in range(LEN):
            d = matches[i].string[pos]
            if pos in config[i]:
                solution[pos] &= { d }
            else:
                solution[pos] -= { d }
            if len(solution[pos]) == 0:
                if printSolution:
                    print('fail!')
                    print(config)
                    printl(solution)
                return False
    if printSolution:
        print('success!')
        print(config)
        printl(solution)
    return True


def find(config):
    maxlen = 0
    while True:
        success = checksoft(config, printSolution=DEBUG)
        if success and len(config) == len(matches):
            success = check(config, printSolution=DEBUG)
            if success:
                break
        if success:
            sel = nextsel(None, len(config))
            config.append(sel)
            if len(config) > maxlen:
                maxlen = len(config)
                print(config)
        else:
            while(True):
                i = len(config)
                if i == 0:
                    print('i=0: fail')
                    return False
                cursel = config.pop()
                sel = nextsel(cursel, i)
                if sel is not None:
                    config.append(sel)
                    break
    check(config, True)
    
    print('\n'.join([str(m) for m in matches]))
    print('winning config:')
    print(config)

    return True

check([[], [0], [1]])                
find([])

