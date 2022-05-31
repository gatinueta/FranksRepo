#!/usr/bin/perl -w

use strict;
use CGI qw/:standard/;
use POSIX;

print header, start_html( -bgcolor=>"#000000",
			  -text   =>"#FFFFFF",
			  -link   =>"#0000FF",
			  -vlink  =>"#551A8B",
			  -alink  =>"#0000FF",
			  -title => "Photos"), 
  "\n";

print h1("Photos");

my $subdir = param('dir') || "";

POSIX::chdir "../$subdir" or die "can't chdir to ../$subdir: $!";

my %f = ();
opendir DIR, "." or die "can't opendir: $!";

while ($_ = readdir DIR) {
	if (/^photos_/) {
		my @ststr = stat $_ or die "can't stat: $!";
		my $lastmod = $ststr[9];

		$f{$_} = $lastmod;
	}
}

closedir DIR;

my @filelist = sort { $f{$b} <=> $f{$a} } keys %f;

foreach (@filelist) {
	print a({href=>"../$subdir$_/"},"$_");
	print hr, "\n";
}

print end_html;
