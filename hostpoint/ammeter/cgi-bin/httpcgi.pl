#!/usr/bin/perl -w
use CGI;
use CGI::Carp 'fatalsToBrowser';
use strict;

require LWP::UserAgent;

my $q = CGI->new;
print $q->header;

my $url  = $q->param('url') || "http://search.cpan.org";

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
#$ua->env_proxy;

my $response = $ua->get($url);

if ($response->is_success) {
    print $response->decoded_content;  # or whatever
}
else {
    die $response->status_line;
}

