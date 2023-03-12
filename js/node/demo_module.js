var http = require('http');
var dt = require('./myfirstmodule');

http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
  var ct = dt.myDateTime();
  res.write("<p>The date and time are currently: " + ct + "</p>");
  res.end('Hello World!');
}).listen(8080);

