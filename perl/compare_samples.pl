use strict;
use warnings;
use 5.010;

my @h;

my $LIMIT_HOMOLOGY = 3;

while(my $line = <>) {
    my @arr = split /,/, $line;

    my $sample_no = shift @arr;
    my %sim;
    foreach my $i (0..$#arr) {
        my $value = $arr[$i];
        my $l = $h[$i]->{$value};
        if (!$l) {
            $l = $h[$i]->{$value} = [];
        }
        foreach my $s (@$l) {
            $sim{$s}++;
        }
        push @$l, $sample_no;
    }
    foreach my $s (keys %sim) {
        if ($sim{$s}>=$LIMIT_HOMOLOGY) {
            say "$sample_no: $s. Matches: $sim{$s}";
        }
    }
}

