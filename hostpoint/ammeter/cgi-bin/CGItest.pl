#!/usr/bin/perl
print "Content-Type: text/html\n\n";

eval { use CGI; };
print $@ if ($@);
print "test end.\n";

