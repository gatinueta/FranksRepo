import re
import fileinput

for line in fileinput.input():
    ms = re.finditer('[A-Z]{3,}[a-z][A-Z]{3,}', line)
    for m in ms:
        if len(m.group()) == 7:
            print(m.group())
            