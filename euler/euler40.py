s='.'
for i in range(1,1000000):
    s += str(i)

res = \
    int(s[1]) *\
    int(s[10]) *\
    int(s[100]) *\
    int(s[1000]) *\
    int(s[10000]) *\
    int(s[100000])

print res


