import re
import fileinput
from collections import defaultdict

ops = {
    'inc': '+=',
    'dec': '-='
}

regs = defaultdict(int)
maxv = 0

for line in fileinput.input():
    m = re.search('(\\w+) (\\w+) (\\S+) if (\\w+) (\\S+) (\\S+)', line)
    if m:
        reg, instr, val, treg, rel, tval = m.groups()
        
        cond = 'regs["{}"] {} {}'.format(treg, rel, tval)
        op = 'regs["{}"] {} {}'.format(reg, ops[instr], val)
        execi = 'if {}: {}'.format(cond, op)
        if regs[reg] > maxv:
            maxv = regs[reg]
#        print(execi)
        exec(execi)
    else:
        print(line, ':no match')
print(regs)

print('max is ', max(regs, key = regs.get))

print('max ever is ', maxv)




