from SOAPpy import WSDL

# you'll need to configure these two values;

_server = WSDL.Proxy('http://localhost:8080/Hubris?wsdl')
result = _server.sayHello( 'Frank');
print result;


