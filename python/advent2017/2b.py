import sys
import re
import itertools

def getres(arr):
    for s in itertools.combinations(numbers, 2):
        ss = sorted(s)
        if ss[1] % ss[0] == 0:
            return ss[1] / ss[0]
        
        
file = open('number2.txt', 'r');

sum = 0
for line in file:
#    print(line)
    line = line.strip()
    numbers = [int(x) for x in re.split('\\t+', line)]
    sum += getres(numbers)
        
file.close()
print(sum)
