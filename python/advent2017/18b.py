import fileinput
import re
from collections import defaultdict

def format(operand, pid):
        if operand == None:
            return None
        elif operand.isalpha():
            return "r[{}]['{}']".format(pid, operand)
        else:
            return operand

instrs = {
    'set': '{} = {}',
    'add': '{} += {}',
    'snd': 'q[1-{2}].append({0}); stopped[1-{2}] = False; sent[{2}] += 1',
    'mul': '{} *= {}',
    'jgz': 'if {0} > 0: ic[{2}] += {1} - 1',
    'rcv': '{0} = q[{2}].pop(0)', 
    'mod': '{} %= {}'
}

p = []
for line in fileinput.input():
    m = re.match('(\\w{3})\s+(\\S)(?:\\s+(\\S+))?\\s*', line)
    if m:
        p.append(m.groups())
    else:
        print(line, ': no match')

sent = [0, 0]
q = [ [], [] ]
ic = [0, 0]
r = [ defaultdict(int), defaultdict(int) ]
r[0]['p'] = 0
r[1]['p'] = 1
stopped = [ False, False ]
pid = 0

while True:
    if not stopped[pid]:
        cinstr = p[ic[pid]]
        op1 = format(cinstr[1], pid)
        op2 = format(cinstr[2], pid)
        op = instrs.get(cinstr[0])
        if op:
            cmdstr = op.format(op1, op2, pid)
#            print(cinstr, cmdstr)
            try:
                exec(cmdstr)
#                print (pid, r[pid], q[pid])
                ic[pid] += 1
            except IndexError:
#                print('nothing to receive')
                stopped[pid] = True
                if stopped[1-pid]:
                    print(sent)
                    break
        else:
            print(cinstr[0], ": unknown")

    pid = 1-pid



