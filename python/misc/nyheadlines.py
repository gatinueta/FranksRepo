import requests
from bs4 import BeautifulSoup

resp = requests.get('http://www.nytimes.com')
b = BeautifulSoup(resp.content, 'html.parser')
headings = b.findAll(attrs={'class': 'story-heading'})
for heading in headings:
#    print('and the type is: ', type(heading))
    t = heading.get_text()
    t = t.encode('utf-8')
    print ("- {}".format( t.rstrip().lstrip()))
