use strict;
use warnings;

use bignum;

sub gettuples_with_sum($$);

sub round($) { 
  my($number) = shift; 
  return int($number + .5); 
} 

sub gettuples_with_sum($$) {
  my ($n, $sum) = @_;

  if ($n == 1) {
    return ( [ $sum ] );
  } else {
    my @tuples = ();
    for (my $i=0; $i<=$sum; $i++) {
      foreach my $tuple (gettuples_with_sum( $n-1, $sum-$i )) {
        push @tuples, [ $i, @$tuple];
      }
    }
    return @tuples;
  }
}


my $sum=0;
my $fermat_was_wrong = 0;

for (my $sum=0; !$fermat_was_wrong; $sum++) {
  my @three_tuples = gettuples_with_sum( 3, $sum );

  foreach my $t (@three_tuples) {
    my ($a, $b, $n) = @$t;

    if ($a==0 or $b<$a or $n<2) {
      next;
    }

    my $c = round( ($a**$n + $b**$n) ** (1/$n) );
    if ($a ** $n + $b ** $n == $c ** $n) {
      print "$a^$n + $b^$n = $c^$n\n";
      if ($n>2) { 
        $fermat_was_wrong = 1;
      }
    }
  }
}

