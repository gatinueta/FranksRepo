from random import randint

def indexall(l, e):
    return [i for i, x in enumerate(l) if x == e]

def debug_print(s):
    print(s)

def score(s, sol):
    bulls, cows = [False] * len(sol), [False] * len(sol)
    nof_bulls, nof_cows = 0, 0
    debug_print('attempt {} for solution {}'.format(s, sol))
    #count the bulls first, memorizing their positions
    for i,c in enumerate(sol):
       if i<len(s) and s[i] == c:
        debug_print('bull at index {}: {}'.format(i, c))
        bulls[i] = True
        nof_bulls += 1
    
    #now count the cows, where no bull or cow has been awarded
    for i,c in enumerate(s):
      if not bulls[i]:
        for mi in indexall(sol, c):
           debug_print('{} index {}, solution index {}...'.format(c, i, mi))
           if not bulls[mi] and not cows[mi]:
                debug_print('scored at solution index {}'.format(mi))
                cows[mi] = True
                nof_cows += 1
                break
    debug_print bulls, cows

    return nof_bulls, nof_cows

sol = str(randint(1000, 9999))
attempts = 0

# print score('1174', '8111')
# print score('8111', '1174')
while True:
    s = raw_input('enter number: ')
    attempts += 1
    nof_bulls, nof_cows = score(s, sol)

    if nof_bulls == len(sol):
        print('congrats, the number is {} ({} attempts)'.format(sol, attempts))
        break
    print('{} bulls, {} cows'.format(nof_bulls, nof_cows))


