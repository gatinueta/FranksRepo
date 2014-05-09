use warnings;
use strict;

use Data::Dumper; 

sub g { 
  my $n = shift; 
  return 4*3*5*$n+1; 
} 

sub g2 { 
  my $n = g(shift); 
  return [ $n, $n%7 ]; 
} 

foreach (1..100) { 
  my $l = g2($_); 
  print Dumper $l if $l->[1] == 0; 
}

LOOP:
foreach my $n (1..1000) {
  foreach my $div (2..6) {
    next LOOP if ($n%$div != 1);
  }
  next if ($n%7 != 0);

  print "ha: $n!\n";
}

