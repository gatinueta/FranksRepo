import http.client
import ssl

conn = http.client.HTTPSConnection('www.python.org', context=ssl._create_unverified_context())
conn.request('GET', '/')
resp = conn.getresponse()
print(resp.status)
print(str(resp.headers))
print(resp.read().decode())

