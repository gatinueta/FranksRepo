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

# number of snd for each program
sent = [0, 0]
# snd/rcv queue for each program
q = [ [], [] ] 
# instruction counter for each program
ic = [0, 0]
# register values for each program
r = [ defaultdict(int), defaultdict(int) ]
r[0]['p'] = 0
r[1]['p'] = 1
# set to True of queue is empty on rcv
stopped = [ False, False ]
compiled = [ {}, {} ]

# current executing pid
pid = 0

while True:
    if not stopped[pid]:
        cmdstr = compiled[pid].get(ic[pid])
        if cmdstr == None:
            # get current instruction
            cinstr = p[ic[pid]]
            # convert operands
            op1 = format(cinstr[1], pid)
            op2 = format(cinstr[2], pid)
            op = instrs[cinstr[0]]
            cmdstr = op.format(op1, op2, pid)
            compiled[pid][ic[pid]] = cmdstr
        try:
            exec(cmdstr)
            ic[pid] += 1
        except IndexError:
            # rcv on empty queue
            stopped[pid] = True
            if stopped[1-pid]:
                # both stopped. terminate
                print(sent)
                break
    pid = 1-pid


print(compiled)

