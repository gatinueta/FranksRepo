from suds.client import Client
import logging
import sys

url = 'http://localhost:8080/Hubris?wsdl';

 
logging.basicConfig(level=logging.DEBUG)

handler = logging.StreamHandler(sys.stderr)
logger = logging.getLogger('suds.transport.http')
logger.setLevel(logging.DEBUG), handler.setLevel(logging.DEBUG)
logger.addHandler(handler)

client = Client(url);
print client;

result = client.service.sayHello('Frank');
print result;

print client.last_sent()


