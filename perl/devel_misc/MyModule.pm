package MyModule;

use Data::Dumper;
use Exporter 'import';
use strict;

our @EXPORT_OK = qw(one two three four five six);
our @EXPORT_FAIL = qw(five six);

*two = \*STDIN;

BEGIN {
    print "loading...\n";
}

sub export_fail {
    print "called export_fail with @_\n";
    return;
}

sub one {
    print "called one with @_\n";
}

END {
    print "end.\n";
}

1;

