m = [ '1234', '5678', '9012', '3456' ]

def split(m):
    s = len(m[0])
    
    if s%2 == 0:
        d = 2
    else:
        d = 3
        
    for y in range(int(s/d)):
        for x in range(int(s/d)):
            for yd in range(d):
                blocks.append(m[y+yd][x*d:x*d+xd])
                
    