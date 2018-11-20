
def f(n):
    for i in range(80):
        print('check ' + str(i))
        if i%n== 0:
            yield i


for i in f(7):
    print(i)

    
