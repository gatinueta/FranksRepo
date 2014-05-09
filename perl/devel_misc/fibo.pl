use strict;
use warnings;

use bigint;

my ($f1, $f2) = (1, 1);

my $f2n = 2;

while (length $f2 < 1000) {
  my $nextf = $f1+$f2;
  $f1 = $f2;
  $f2 = $nextf;
  $f2n++;
}

print "F[$f2n]: $f2 (", length $f2, ")\n";

