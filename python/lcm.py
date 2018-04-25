from math import gcd

def lcm(a, b):
    """Compute the lowest common multiple of a and b"""
    return int(a * b / gcd(a, b))

res = 1
for i in range(1,101):
      res = lcm(res, i)

print(res)
