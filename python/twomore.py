import sys

tl = ''


for c in sys.argv[1]:
    pos = ord(c)-ord('a')
    if 0 <= pos < 26:
        pos = (pos+2)%26
    tl += chr(ord('a')+pos)

print(tl)


