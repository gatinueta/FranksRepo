import urllib.request
import re

n = 12345
n = 8022
times = 0

while times < 500:
    url = "http://www.pythonchallenge.com/pc/def/linkedlist.php?nothing={}".format(n)
    req = urllib.request.urlopen(url)
    result = req.read().decode('utf-8')
    m = re.search('\\d+$', result)
    print(result, m.group())
    n = m.group()
    times += 1






