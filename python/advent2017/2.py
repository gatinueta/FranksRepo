import sys
import re

file = open('number2.txt', 'r');

sum = 0
for line in file:
#    print(line)
    line = line.strip()
    numbers = [int(x) for x in re.split('\\t+', line)]
    if len(numbers) > 0:
        maxn = max(numbers)
        minn = min(numbers)
        sum += maxn-minn
        
file.close()
print(sum)
