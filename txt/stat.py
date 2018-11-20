import re
import unicodedata
import io
from collections import defaultdict

def normalize(s):
    return s.lower()

file = 'deu_news_1995_30K-sentences.txt'

f = io.open(file, mode="r", encoding="utf-8")
r = re.compile(r'\W+', re.UNICODE)

d = defaultdict(int)

for line in f:
    arr = r.split(line)
    for word in arr:
        word = normalize(word)
        print(word.encode('utf-8'))
        for c in word:
            print(unicodedata.name(c), unicodedata.category(c))
        d[word] += 1

for k in d.keys():
    print (k, d[k])
