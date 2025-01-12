import gmpy2

from sympy.ntheory import factorint
from sympy.ntheory import discrete_log
    
from math import isqrt

import gmpy2
from math import isqrt

def powmod(base, exp, n):
    res = gmpy2.powmod(base, exp, n)
    if res > n-2:
        return res - n
    else: 
        return res

primes = [
2069,2081,2083,2087,2089,2099,2111,2113,2129,2131,2137,2141,2143,2153,2161,
2179,2203,2207,2213,2221,2237,2239,2243,2251,2267,2269,2273,2281,2287,2293,
2297,2309,2311,2333,2339,2341,2347,2351,2357,2371,2377,2381,2383,2389,2393,
2399,2411,2417,2423,2437,2441,2447,2459,2467,2473,2477,2503,2521,2531,2539,
2543,2549,2551,2557,2579,2591,2593,2609,2617,2621,2633,2647,2657,2659,2663,
2671,2677,2683,2687,2689,2693,2699,2707,2711,2713,2719,2729,2731,2741,2749,
2753,2767,2777,2789,2791,2797,2801,2803,2819,2833,2837,2843,2851,2857,2861,
2879,2887,2897,2903,2909,2917,2927,2939,2953,2957,2963,2969,2971,2999,3001,
3011,3019,3023,3037,3041,3049,3061,3067,3079,3083,3089,3109,3119,3121,3137,
]

cmn = [
    561, 1105, 1729, 2465, 2821, 6601, 8911, 10585, 15841, 29341, 41041, 46657, 52633, 62745, 63973, 75361, 101101, 115921, 126217, 162401, 172081, 188461, 252601, 278545, 294409, 314821, 334153
]


def printfactors(n):
    print(f'... {n} has factors {factorint(n)}')

def test(numberlist):
  for n in numberlist:
    np = 0
    for i in (2,3,5,7,11,13,17,23,29,31):
        exp = (n-1)//2
        res = powmod(i, exp, n)
        print(f'{i} ^ {exp} = {res} mod {n}')
        if res == -1:
            print('probably prime')
            if exp % 6 == 0:
                print(f'... {exp} is divisible by 6')
                printfactors(exp)
                dl = discrete_log(n, -1, i)
                res = powmod(i, dl, n)
                print(f'... computed log: {i} ^ {dl} = {res} mod {n}')
                printfactors(dl)
                printfactors((n-1)//dl)
            np += 1
        elif res != 1:
            print('cannot be prime')
            np = -1
            break
    if np < 0:
        print(f'****    {n} is not prime')
    elif np > 1:
        print(f'****    {n} is most probably prime (encountered {np} probable primitive roots)')
    else:
        print(f'****    {n}: only 1 primitive root candidate, rare - further check needed!')

print("\n***** carmichael *****\n")
test(cmn)
print("\n**** primes ******\n")
test(primes)

print("\n ****** random numbers ******\n")
test(range(2000, 2100))
