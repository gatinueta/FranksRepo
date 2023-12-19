import fileinput
import re

h = {
    'five': 7,
    'four': 6,
    'full': 5,
    'three': 4,
    'twopair': 3,
    'pair': 2,
    'high': 1
}

c = {
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    '6': 6,
    '7': 7,
    '8': 8,
    '9': 9,
    'T': 10,
    'J': 1,
    'Q': 12,
    'K': 13,
    'A': 14
}

def classify_streak(hand):
    lc = ' '
    streaks = []
    streak = [] 
    js = 0
    l = list(hand)
    while l.count('J') > 0:
        l.remove('J')
        js += 1

    sortedhand = sorted(l)
    for c in sortedhand:
        if c==lc:
            streak += c
        else:
            if len(streak):
                streaks.append(streak)
            streak = [ c ]
            lc = c
    if len(streak):
        streaks.append(streak)
    if len(streaks)==0:
        streaks = [[]]
    streaks.sort(key=len, reverse=True)
    for i in range(js):
        streaks[0].append('J')
    print(f'streaks:{streaks}')
    match(len(streaks[0])):
        case 5:
            return 'five'
        case 4:
            return 'four'
        case 3:
            if len(streaks[1]) == 2:
                return 'full'
            else:
                return 'three'
        case 2:
            if len(streaks[1]) == 2:
                return 'twopair'
            else:
                return 'pair'
        case _:
            return 'high'

def classify(hand):
    cl = [ h[classify_streak(hand)] ]
    for i in hand:
        cl.append(c[i])
    return cl

    
hands = [] 
for line in fileinput.input():
    if m := re.match('(\\w+) (\\d+)', line):
        print(f'hand={m.group(1)}, bid={m.group(2)}')
        hand=m.group(1)
        bid=int(m.group(2))
        hands.append({ 'hand': hand, 'bid': bid, 'classify': classify(hand) })
hands.sort(key=lambda hand: hand['classify'])
sum = 0
for i in range(len(hands)):
    print(f'hand={hands[i]}, rank={i+1}')
    sum += (i+1)*hands[i]['bid']

print(f'sum={sum}')

