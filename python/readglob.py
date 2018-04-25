import glob
import fileinput
import collections

maxlen = 10
files = glob.glob('*.py')
buf = collections.deque([], maxlen)
for line in fileinput.input(files):
    if fileinput.isfirstline():
        print('first line')
    buf.append(line)
    print(fileinput.filename(), fileinput.filelineno())

