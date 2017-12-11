import re
import fileinput
from collections import defaultdict

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

# checks node and its subtrees for mismatches
def mismatches(node):
    totweights = [ totweight[c] for c in ch[node] ]
    if len(totweights) > 0 and max(totweights) != min(totweights):
        # found a mismatch for node, now check the subtrees
        subtree_mismatches = False
        for n in ch[node]:
            if mismatches(n):
                subtree_mismatches = True
        if not subtree_mismatches:
            # none of the subtrees has a mismatch, now find the direct successor
            # node with a different total weight
            weights = [ w[c] for c in ch[node] ]
            print(node, ' has mismatch: ', list(zip(ch[node], totweights, weights)))
            # build a histogram with a list of child indexes for each total weight
            h = defaultdict(list)
            for i, weight in enumerate(totweights):
                h[weight].append(i)
            # sort by list length so the index of the child node with the wrong
            # weight will come first
            index_asc = sorted(h, key = lambda k: len(h[k]))
            print(h)
            if len(index_asc) > 1:
                iwrong = h[index_asc[0]][0]
                iright = h[index_asc[1]][0]
                corr = totweights[iright] - totweights[iwrong]
                print('correcting {} by {} to {}'.format(weights[iwrong], corr, weights[iwrong] + corr))
        print('finished checking children of ', node)
        return True
    else:
        # no mismatch for this node
        return False

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

