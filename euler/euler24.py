def p(prefix, l):
    if len(l)==1:
        return [ prefix + l ]
    else:
        s = []
        for i in range(len(l)):
            e = l[i]
            s += p(prefix + [e], l[:i] + l[i+1:])
        return s

perms = p([], range(10))
print perms[1000000-1]






