use strict;
use warnings;
use 5.010;

sub lens {
    my $ls;
    my $count = 0;
    foreach my $s (@_,'sentinel') {
        if ($s ne $ls) {
            say "$ls: $count" if defined($ls);
            $count=0;
            $ls = $s;
        }
        $count++;
    }
}

lens(1,1,10,20,20,20,5,-2,-2, 100,100,100,100,2,5,5,1,4,2,2,2);

