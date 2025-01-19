
def quicksort(liste, depth):
    if len(liste) < 2:
        return liste

    print(f'before: {liste}, depth {depth}')
    pivot = liste.pop()
    print(f'pivot: {pivot}')

    less_liste = []
    more_liste = []

    for el in liste:
        if el < pivot:
            less_liste.append(el)
        else:
            more_liste.append(el)
    print(f'after: {less_liste} <= {pivot} <= {more_liste}')        
    return quicksort(less_liste, depth+1) + [ pivot ] + quicksort(more_liste, depth+1)

l = [1, 10, -3, 4, 100, 2, 8, 7, 20, 4, 0, -1, 3]
print('quicksort result: ', quicksort(l, 0)) 

def vereinigen(l, r):
    il = ir = 0
    result = []
    while il < len(l) or ir < len(r):
        if ir == len(r):
            result.append(l[il])
            il+=1
        elif il == len(l):
            result.append(r[ir])
            ir += 1
        elif l[il] <= r[ir]:
            result.append(l[il])
            il += 1
        else:
            result.append(r[ir])
            ir += 1
    print('vereinigung von ', l, ' und ', r , ' ist ', result)
    return result        

def mergesort(liste, tiefe):
    print(tiefe, '...')
    if len(liste) <= 1:
        return liste
        
    mitte = len(liste)//2
    
    linkeliste = liste[0:mitte]
    rechteliste = liste[mitte:len(liste)]
    
    print('  ' * tiefe, 'linkeliste: ', linkeliste,' rechteliste: ', rechteliste)
    sortiertelinkeliste = mergesort(linkeliste, tiefe+1)
    sortierterechteliste = mergesort(rechteliste, tiefe+1)
    print('  ' * tiefe, 'sortiertelinkeliste: ', sortiertelinkeliste, 'sortierterechteliste: ', sortierterechteliste)

    return vereinigen(sortiertelinkeliste, sortierterechteliste)


print('Resultat: ', mergesort([1, 10, -3, 4, 100, 2, 8, 7, 20], 0), "\n")

def mergesort_bottomup(liste):
    lol = [ [ el ] for el in liste ]

    while len(lol) > 1:
        print(f'LOL: {lol}')
        result_lol = []
        
        while len(lol) > 1:
            l1 = lol.pop()
            l2 = lol.pop()
            result_lol.append(vereinigen(l1, l2))
    
        result_lol.extend(lol)
        lol = result_lol
    return result_lol.pop()
    
print('Resultat: ', mergesort_bottomup([1, 10, -3, 4, 100, 2, 8, 7, 20]))

    

