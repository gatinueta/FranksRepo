#!/usr/bin/perl -w
use strict;
use CGI;
use IO::Socket::INET;

my $q;

$SIG{__DIE__} = sub {
	print $q->h1(@_);
	print $q->end_html;
	exit 1;
};

$q = new CGI;

print $q->header, $q->start_html;

print $q->p("Hello ", $q->remote_host(), "!\n");
  
my $port = $q->param("port") || 39551;
my $host = $q->param("host") || "80.219.195.109";
my $sock = IO::Socket::INET->new(
	PeerAddr => $host,
	PeerPort => $port,
	Proto    => 'tcp',
	Type => SOCK_STREAM,
	Timeout => 20
) or die "can't open socket: $!\n";
	
print $sock "tachwohl\n" or die "can't write to socket: $!\n";

my $response = <$sock>;

if (defined($response)) {
	print "read from socket: $response\n";
} else {
	print "couldn't read from socket: $!\n";
}

close $sock;

print $q->end_html;

							  