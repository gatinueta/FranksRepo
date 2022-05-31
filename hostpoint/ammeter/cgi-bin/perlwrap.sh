#!/bin/sh
echo "Content-type: text/html"
echo ""
echo "<html><pre>"
pwd
ls -l
type -a perl
echo "now starting...";
perl ./encodings_cgi.pl 2>&1
echo "direct";
./encodings_cgi.pl 2>&1
echo "ended.";
echo "</pre></html>"

