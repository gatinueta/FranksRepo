from random import randint

def randlist():
    return [randint(0, 10) for x in range(randint(5, 10))]

def sharedelems(l1, l2):
    return list(set([x for x in l1 if x in l2]))

l1, l2 = randlist(), randlist()
print ("lists {} and {} share {}".format(l1, l2, sharedelems(l1, l2)))

