#! /usr/bin/perl -w


use strict;
use File::Find ();

use CGI qw/:standard/;
print header,
      start_html('all files');
chdir "..";

# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats.

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

sub wanted;



# Traverse desired filesystems
File::Find::find({wanted => \&wanted}, '.');
exit;


sub check($$) {
    my ($name, $lname) = @_;
    my $res = open FILE, $lname or warn "can't open $name: $!\n";
    if (!$res) { return; }
    while (<FILE>) {
    	if (/DSC/) {
    		chomp;
    		print "$name: $_\n";
    	}
    }
    close FILE;
}

sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    /^.*\.html\z/si
    && check($name, $_);
}
