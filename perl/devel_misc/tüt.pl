#!/usr/bin/perl -w
use strict;
use warnings;

my $i=0;

while(1) {
	print "$i nicht gefunden.\n";
	last if (++$i > 1000);
}

