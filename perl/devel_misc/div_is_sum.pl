use strict;
use bigrat;

sub y1($) { 
  my ($x)=@_; 
  return $x*$x/(1/1-$x); 
} 

sub denominator {
  my ($arg) = @_;

  return (ref ($arg) eq "Math::BigRat") ? $arg->denominator() : 1;
}

my @arr = ();
foreach my $i (-100..200) {
  my $x = $i/100; 
  my $y = y1($x);
  push @arr, [ $x, $y ];

}

my @sorted_arr = sort{ denominator($a->[1]) <=> denominator($b->[1]) } @arr;

foreach my $el (reverse @sorted_arr) {
  my ($x, $y) = @$el;
  print "($y)/($x)=",($y/$x), ", $y+$x=", ($y+$x), "\n";
}


