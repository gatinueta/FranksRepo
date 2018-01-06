import re

regex = '''\\n*In state (\\w):\\s*
\\s*If the current value is 0:\\s*
\\s*- Write the value (\\d).\\s*
\\s*- Move one slot to the (\\w+).\\s*
\\s*- Continue with state (\\w).\\s*
\\s*If the current value is 1:\\s*
\\s*- Write the value (\\d).\\s*
\\s*- Move one slot to the (\\w+).\\s*
\\s*- Continue with state (\\w).\\s*
'''

class S:
    def __repr__(self):
        return str(self.__dict__)

f = open('25.txt', 'r')
m = re.search('Begin in state (\\w)', f.readline())
curstate = m.group(1)
m = re.search('Perform a diagnostic checksum after (\\d+) steps.', f.readline())
dsteps = int(m.group(1))

string = f.read()
states = {}
cre = re.compile(regex, flags=re.MULTILINE)
dirs = { 'left':-1, 'right':1 }

for m in cre.finditer(string):
    print(m.group(0))
    s = S()
    name = m.group(1)
    s.action = (S(),S())
    s.action[0].write = int(m.group(2))
    s.action[0].dir = dirs[m.group(3)]
    s.action[0].tostate = m.group(4)
    s.action[1].write = int(m.group(5))
    s.action[1].dir = dirs[m.group(6)]
    s.action[1].tostate = m.group(7)
    states[name] = s

print(states)

tape = [0]
pos = 0
steps = 0
while steps < dsteps:
    state = states[curstate]
    c = tape[pos]
    tape[pos] = state.action[c].write
    pos += state.action[c].dir
    if pos<0:
        tape.insert(0, 0)
        pos += 1
    elif pos>=len(tape):
        tape.append(0)
    curstate = state.action[c].tostate
    steps += 1

print(sum(tape))

