class Node:
    def __init__(self, el):
        self.el = el
        self.next = None
     def append(self, el):
        node = self
        while node.next != None:
            node = node.next
        node.next = Node(el)

n = Node(1)
