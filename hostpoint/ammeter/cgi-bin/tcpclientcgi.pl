#!/usr/bin/perl -w

use strict;
use CGI;
use IO::Socket;

my $q = CGI->new;
print $q->header;

print $@ if $@;

my $host = $q->param('host') || 'localhost';
my $port = $q->param('port') || 80;
my $request = $q->param('request') || "Hello there!\n";
print
      $q->start_html('tcpclient'),
      $q->p("host: $host, port: $port\n");

my $sock = new IO::Socket::INET ( 
  PeerAddr => $host, 
  PeerPort => $port, 
  Proto => 'tcp',
); 

die "Could not create socket: $!\n" unless $sock; 
$sock->timeout(10);
print $sock $request; 
print $q->p("reading...\n");
while (defined(my $read = <$sock>)) {
  print $q->pre($q->escapeHTML($read));
} 
close($sock);

print $q->end_html;

