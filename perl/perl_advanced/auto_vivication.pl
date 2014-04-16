use strict;
use warnings;
use 5.010;

my $foo; 
if (exists $foo->{"bla"}[1]->{"XXX"}) { 
    say "Igrec"; 
}

use Data::Dumper;
print Dumper($foo);

