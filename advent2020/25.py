#CARDLOOP = 8
#DOORLOOP = 11

def transform(sn, loopsize, target=None):
    n = 1
    for i in range(loopsize):
        n *= sn
        n %= 20201227
        if n == target:
            return i+1
    return n


#example
TARGETDOOR = 17807724
TARGETCARD = 5764801

TARGETCARD = 5099500
TARGETDOOR = 7648211

def findloopsize_naive(targetkey):
    for loopsize in range(1,100000000):
        if transform(7, loopsize) == targetkey:
           return loopsize; 
    return None

def findloopsize(targetkey):
    return transform(7, 100000000, targetkey)

doorloopsize = findloopsize(TARGETDOOR)
cardloopsize = findloopsize(TARGETCARD)

print ('doorloopsize={}, keycalc={}'.format(doorloopsize, transform(7, doorloopsize)))
print ('cardloopsize={}, keycalc={}'.format(cardloopsize, transform(7, cardloopsize)))
print ('key card={}'.format(transform(TARGETDOOR, cardloopsize)))
print ('key door={}'.format(transform(TARGETCARD, doorloopsize)))

