denom = (1, 2, 5, 10, 20, 50, 100, 200);

def sum(start, aim):
    if start >= len(denom):
        if (aim==0):
            return [()]
        else: 
            return []
    n=0;
    res = [];
    while True:
        ts = n*denom[start]
        if ts > aim:
            break
        m = sum(start+1, aim-ts);
        res += [ [ n, e ] for e in m];
        print "res=", res
        n+=1;
    
    return res;

arr = sum(0, 200)
for w in arr:
    print (",".join ([ w[i] * denom[i] + "p" for i in range(len(denom)) ]))

print (len(arr)+ " solutions.")


