# Quadrat hat Seitenlnge sqrt(2)
# bis zur Seite sind es 1 - sqrt(1 - (sqrt(2)/2)**2)
# Also Lnge Achteck ** 2 = (1-sqrt(1-sqrt(2)/2)**2)**2 + (sqrt(2)/2)**2

from math import sqrt

f = 4
a = sqrt(2)

while(True):
    print('{} * {} == {}'.format( a, f, a*f))
    a = sqrt( (1 - sqrt(1-a/2)**2)**2 + (a/2)**2)
    f *= 2

