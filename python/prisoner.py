import random
import sys

class switch:
    def __init__(self):
        self.state = random.random() > .5
    def getstate(self):
        return self.state
    def toggle(self):
        self.state = not self.state
        print('state toggled to {}'.format(self.state))

s = switch()
print(s.getstate())

class prisoner:
    def __init__(self, n, iscounter):
        self.n = n
        self.iscounter = iscounter
        if iscounter:
            self.count = 0
        else:
            self.acted = 0
    def act(self, sw):
        print('{} acted (counter: {})'.format(self.n, self.iscounter))
        if self.iscounter:
            if sw.getstate():
                self.count += 1
                sw.toggle()
            if self.count == 2*(nprisoners-1)-1:
                print "got it!"
                sys.exit()

        else:
            if not sw.getstate():
                if self.acted < 2:
                    self.acted += 1
                    sw.toggle()

                
nprisoners = int(sys.argv[1])
prisoners = [ prisoner(i, False) for i in range(nprisoners-1) ]
prisoners.append(prisoner(nprisoners-1,True))
sw = switch()

while(True):
    n = random.randint(0, nprisoners-1)
    prisoners[n].act(sw)
        
