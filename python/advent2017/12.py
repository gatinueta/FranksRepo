import re
import fileinput
from collections import defaultdict

pipe = defaultdict(list)
unreachables = set()

def find_group(root):
    todo = { root }
    reachable = { root }
    global unreachables

    while len(todo) > 0:
        new_todo = set()
        for n in todo:
            for i in pipe[n]:
                if i not in reachable:
                    reachable.add(i)
                    new_todo.add(i)
        todo = new_todo

    print(root, ': ', len(reachable))
    unreachables = unreachables.difference(reachable)
    return len(reachable)


for line in fileinput.input():
    m = re.search('(\\d+) <-> (.+)', line)
    if m:
        pl, pr_str = m.groups()
        pr = re.split(',\\s*', pr_str)
        unreachables.add(int(pl))
        for r in pr:
            pipe[int(pl)].append(int(r))
    else:
        print(line, ': no match')

totsize = 0
ngroups = 0
while len(unreachables) > 0:
    size = find_group(next(iter(unreachables)))
    totsize += size
    ngroups += 1

print(ngroups, totsize)
