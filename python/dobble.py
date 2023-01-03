
NS = 8

l1 = [ { 'el': i, 'c': None } for i in range(NS) ]

lol = [ l1 ]
lastsym = NS-1

def nextl(lol):
    global lastsym
    nl = []
    cln = len(lol)
    for (ln, l) in enumerate(lol):
        c = False
        for e in l:
            if not c and e['c'] is None:
                e['c'] = cln
                c = True
                nl.append( { 'el': e['el'], 'c': ln } )
        if not c:
            return None
    while len(nl) < NS:
        lastsym += 1
        nl.append( { 'el': lastsym, 'c': None } )

    return nl

while True:
    nl = nextl(lol)
    if nl is None:
        break
    lol.append(nl)


for l in lol:
    print(l)
    
