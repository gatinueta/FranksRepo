use strict;
use warnings;
use 5.010;

my @l = (1,1,2,3,3,2,4,4,4,1,1,0);

my (@al, @nl);

foreach my $e (@l) {
    if (@nl > 0 && $nl[0] != $e) {
        push @al, [@nl];
        @nl = ();
    }
    push @nl, $e;
#    say "$e: ", scalar @nl;
}
push @al, [@nl];

use Data::Dumper;
print Dumper @al;

use List::Gather;

my @al = gather { 
    for my $e (@l) {
        take $e;
    }
}


    
