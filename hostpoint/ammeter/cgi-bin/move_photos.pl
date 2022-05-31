#!/usr/bin/perl -w
use strict;
use CGI qw/:standard/;

my $cgi = new CGI;

print $cgi->header, $cgi->start_html;
chdir "../photos/";
my @dirs = glob("photos_*");
print join ", ", @dirs;

foreach(@dirs) {
	rename $_, "../$_" or warn "can't rename $_: $!\n";
}

print $cgi->end_html;


