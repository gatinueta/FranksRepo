use strict;
use warnings;
use 5.010;

use List::Util 'sum';

my @divisors = ();
my $max = shift || 28123 ;
foreach my $n (1..$max) {
    for (my $f=2; (my $prod = $f*$n) <= $max; $f++) {
        push @{ $divisors[$prod] }, $n;
        #$sum_divisors[$prod] += $n;
    }
}
use Data::Dumper;

#say Dumper \@divisors;

my @ab_numbers;

foreach my $n (2..$max) {
    push @ab_numbers, $n if (sum (@{ $divisors[$n] }) > $n);
}

say Dumper \@ab_numbers;

my @as_sum_ab = ();

foreach my $ni (0..$#ab_numbers) {
    foreach my $mi ($ni..$#ab_numbers) {
        my ($n,$m) = ($ab_numbers[$ni], $ab_numbers[$mi]);
        push @{ $as_sum_ab[$n+$m] }, [$n,$m];
    }
}

#say Dumper \@as_sum_ab;

my @not_as_sum_ab =  grep { !defined($as_sum_ab[$_]) } 1..$#as_sum_ab;

say Dumper \@not_as_sum_ab;

say "the sum is ", sum @not_as_sum_ab;



