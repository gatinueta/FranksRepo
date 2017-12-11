import sys

file = open('number.txt', 'r');

s = file.read()

s = s.strip()
l = len(s)

sum = 0
for idx, val in enumerate(s):
    if val == s[(idx+int(l/2)) % l]:
        print('we are at ', idx)
        sum += int(val)
        
file.close()
print(sum)
