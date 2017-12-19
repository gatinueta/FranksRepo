import fileinput
import re
from collections import defaultdict

instrs = {
    'set': '{} = {}',
    'add': '{} += {}',
    'snd': 'snd = {}',
    'mul': '{} *= {}',
    'jgz': 'if {} > 0: ic += {} - 1',
    'rcv': 'if {0} > 0: {0} = snd; stop = True', 
    'mod': '{} %= {}'
}

p = []
for line in fileinput.input():
    m = re.match('(\\w{3})\s+(\\S)(?:\\s+(\\S+))?\\s*', line)
    if m:
        p.append(m.groups())
    else:
        print(line, ': no match')

snd = None
ic = 0
r = defaultdict(int)
stop = False

while not stop and 0 <= ic and ic < len(p):
    cinstr = p[ic]

    op1 = "r['{}']".format(cinstr[1])
    if cinstr[2] == None:
        op2 = None
    elif cinstr[2].isalpha():
        op2 = "r['{}']".format(cinstr[2])
    else:
        op2 = cinstr[2]

    op = instrs.get(cinstr[0])
    if op:
        cmdstr = op.format(op1, op2)
        print(cinstr[0], cmdstr)
        exec(cmdstr)
    else:
        print(cinstr[0], ": unknown")

    ic += 1

print(snd)


