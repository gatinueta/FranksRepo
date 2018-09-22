import random
from copy import copy

DEBUG = 0

def debug_print(*l):
    if DEBUG:
        print(l)
class Config:
    def __init__(self, m, c, b):
        self.m = m
        self.c = c
        self.b = b

    def apply(self, move):
        return Config(self.m + move.m, self.c + move.c, self.b + move.b)

    def reverse(self, init_config):
        return Config(init_config.m - self.m, init_config.c - self.c, init_config.b - self.b)

    def __eq__(self, other):
        return self.m == other.m and self.c == other.c and self.b == other.b
    def __str__(self):
        #return "config[m = {}, c = {}, b = {}]".format(self.m, self.c, self.b)
        return ''.join(['m'] * self.m + ['c'] * self.c + ['b'] * self.b)
    def __hash__(self):
        return hash((self.m, self.c, self.b))
    def print_stack(self, stack):
        config = copy(self)
        print(config)
        for e in stack:
            config = config.apply(e.current())
            print('{}: {}, {}'.format(str(e.current()), str(config), str(config.reverse(self))))
        print('')

DIR = { 1: '<=', -1: '=>' }

class Move(Config):
    def apply(self, c):
        return Config(c.m + self.m, c.c + self.c, c.b + self.b)
    def reverse(self):
        return Move(-self.m, -self.c, -self.b)
    def __str__(self):
            #return "move[m = {}, c = {}, b = {}]".format(self.m, self.c, self.b)
            return DIR[self.b] + ''.join(['m']*abs(self.m) + ['c']*abs(self.c)) 
MOVES = [ 
    Move(-1, -1, -1), Move(-1, 0, -1), Move(0, -1, -1), Move(-2, 0, -1), Move(0, -2, -1),
    Move(1, 1, 1), Move(1, 0, 1), Move(0, 1, 1), Move(2, 0, 1), Move(0, 2, 1)
]

# missionary must be on the boat
#MOVES = filter(lambda m: m.m != 0, MOVES)

debug_print(', '.join(str(m) for m in MOVES))
def legal_config(config):
    return config.m >= 0 and config.c >= 0 and config.b >= 0 and (config.m == 0 or config.c <= config.m)

def islegal_config(config, init_config, visited_configs):
    reverse_config = config.reverse(init_config) 
    return legal_config(config) and legal_config(config.reverse(init_config)) and not config in visited_configs

def findPoss(config, init_config, visited_configs):
    return [ lm for lm in MOVES if islegal_config(config.apply(lm), init_config, visited_configs) ]

class StackElem:
    def __init__(self, poss, pi):
        self.poss = poss
        self.pi = pi
    def current(self):
        return self.poss[self.pi]
    def __str__(self):
        return "poss = {}, pi = {}".format( '; '.join(str(p) for p in self.poss), self.pi)

def print_stack(stack):
    for i in stack:
        print(str(i))
    print()

def solve_nonrecursive(init_config, term_configs, stopIfFound):
    current_config = copy(init_config)
    stack = []
    visited_configs = set([current_config])
    while True:
        debug_print(str(current_config), str(current_config.reverse(init_config)))
  
        # check if a solution has been found. print it.
        # find options to advance, store into poss array.
        # push these options on the stack.
        # if no options can be found, backtrack, i.e. pop
        # from stack as long as there are more options..
        # advance to the next option.
        if current_config in term_configs:
            print('found solution:' + str(len(stack)) + ' moves')
            init_config.print_stack(stack) 
            poss = []
            if stopIfFound:
                return True
        else:
            poss = list(findPoss(current_config, init_config, visited_configs))
        if len(poss) > 0:
            poss.sort(key = lambda move: move.m + move.c)            
            stack.append(StackElem(poss, 0))
        else:
            while(True):
                if len(stack) == 0:
                    # we're done. there's no (more) solutions.
                    print('done.')
                    return False;
                e = stack.pop()
                debug_print('backtracking ', str(e))
                visited_configs.remove(current_config)
                current_config = current_config.apply(e.current().reverse())                
                if e.pi < len(e.poss)-1:
                    break

            e.pi += 1
            stack.append(e)
        # now the last stack element contains the next option to be investigated.
        # apply it to the board.
        if DEBUG:
            print_stack(stack)
        e = stack[-1]
        current_config = current_config.apply(e.current())
        visited_configs.add(current_config)

solve_nonrecursive(Config(3, 3, 1), [ Config(0, 0, 0), Config(0, 0, 1)], False)
