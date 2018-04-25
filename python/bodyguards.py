import fileinput
import re

for line in fileinput.input():
    line = '.' + line + '.'
    ms = re.finditer('[A-Z]{3}[a-z][A-Z]{3}', line)
    for m in ms:
#        print(m.group())
        print(line[m.start()-1:m.end()+1])
        if not line[m.start()-1].isupper() and not line[m.end()].isupper():
            print('      : ', m.group())
