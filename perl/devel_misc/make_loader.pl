#!/usr/bin/perl -w
use strict;

while (<>) {
	chomp;
	s/(\d{2})\.(\d{2})\.(\d{4})/$3-$2-$1/g;
	my @f = split /;/;
	foreach my $i (0 .. $#f) {
		if ($f[$i] eq "") {
			$f[$i] = "NULL";
		}
	}
	print join ";", @f;
	print "\n";
}


	
