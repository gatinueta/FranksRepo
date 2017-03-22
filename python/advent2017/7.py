import re
import fileinput

ch = {}
parent = {}
w = {}
totweight = {}

def get_totweight(node):
    children = ch[node]

    totweight[node] = w[node]
    for c in children:
        get_totweight(c)
        totweight[node] += totweight[c]

def mismatches(node):
    totweights = [ totweight[c] for c in ch[node] ]
    if len(totweights) > 0 and max(totweights) != min(totweights):
        weights = [ w[c] for c in ch[node] ]
        print(node, ' has mismatch: ', zip(ch[node], totweights, weights))
        for n in ch[node]:
            mismatches(n)
        print('finished checking children of ', node)

def print_info(node):
    print(node)
    print(totweight[node])
    print('-->')
    for c in ch[node]:
        print_info(c)
    print('<--')

for line in fileinput.input():
    m = re.search('(\\w+) \((\\d+)\)( -> (.+))?', line)
    if m:
        name, weight, rh, childstr = m.groups()

        if childstr:
            children = re.split(',\\s*', childstr)
        else:
            children = []

        print(name, weight, children)
        ch[name] = children
        w[name] = int(weight)
        for n in children:
            parent[n] = name

    else:
        print(line, ': no match')

[ root ] = [ n for n in ch.keys() if not parent.get(n) ]

get_totweight(root)

mismatches(root)

