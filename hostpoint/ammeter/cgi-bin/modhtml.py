from flask import Flask, render_template, request, url_for, flash, redirect
from collections import defaultdict
import math

app = Flask(__name__)

def ord(b, n):
        i = 0
        bb = 1

        if b==1:
                return 1
        if math.gcd(n,b) > 1:
                return float('inf');
        while True:
                i += 1
                bb *= b
                bb %= n
                if bb == 1:
                        return i

def factorization(n):    # (cf. https://stackoverflow.com/a/15703327/849891)
    j = 2
    while n > 1:
        for i in range(j, int(math.sqrt(n+0.05)) + 1):
            if n % i == 0:
                n /= i
                j = i
                yield i
                break
        else:
            if n > 1:
                yield int(n)
                break

def factors(n):
        return list(factorization(n))

def factormap(n):
        factorMap = defaultdict(int)
        for i in factors(n):
                factorMap[i] += 1
        return factorMap

def phi(n):
        if n == float('inf'):
                return n
        res = 1
        factorMap = factormap(n)
        for (k,v) in factorMap.items():
                res *= (k**v - k**(v-1))
        return res

def lcm(a, b):
        return a*b // math.gcd(a, b)

def clambda(n):
        if n == float('inf'):
                return n
        res = 1
        factorMap = factormap(n)
        for (k,v) in factorMap.items():
                if k == 2 and v > 2:
                        res = lcm(res, phi(k**v) // 2)
                else:
                        res = lcm(res, phi(k**v))
        return res

def modinfo(n):
	counts = defaultdict(int)
	maxr = 0
	maxnn = 0
	ordl = []
	ordl_sorted = []
	expl = []
	for nn in range(2, n):
        	r = ord(nn,n)
        	counts[r] += 1

        	if r != float('inf') and r > maxr:
                	maxr = r
                	maxnn = nn
        	ordl.append('ord({},{}) == {} (factors={}, phi={})'.format(nn, n, r, factors(nn), phi(nn)))

	info1 = 'factors({}) = {}, phi({}) = {}, phi(phi({})) = {}, clambda({}) = {}'.format(n, factormap(n), n, phi(n), n, phi(phi(n)), n, clambda(n))
	info2 = 'maxord:{}, smallest el maxord:{}'.format(maxr, maxnn)

	for k in sorted(counts.keys()):
        	ordl_sorted.append('ord {}: {} elements, phi({}) = {}, clambda({}) = {}'.format(k, counts[k], k, phi(k), k, clambda(k)))

	np = 1
	p = maxnn

	while True:
        	expl.append('{} ** {}: {} (ord {}). gcd({},{}) = {}'.format(maxnn, np, p, ord(p, n), np, phi(n), math.gcd(np, phi(n))))
        	if p == 1 or np > n:
                	break
        	np += 1
        	p = (p * maxnn) % n
	return { 'ordl': ordl, 'ordl_sorted': ordl_sorted, 'expl': expl, 'info1': info1, 'info2': info2 }

@app.route('/', methods=('GET','POST'))
def render_mod():
	base = 2
	if request.method == 'POST':
        	base = int(request.form['base'])
	l = [ { 'n': i, 'clambda': clambda(i), 'ord10': ord(10,i) } for i in range(base, base+25) ]
	mod_info = modinfo(base)
	return render_template('mod_template.html', my_list=l, modinfo=mod_info)

if __name__ == '__main__':
    app.run(debug=True, port=5001)

# http://localhost:5001/mod


