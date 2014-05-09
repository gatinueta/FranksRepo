use strict;
use constant MAX => 12001;
use Data::Dumper;

sub subsets($) {
  my $arr_ref = shift;

  my @sets = ();

  my $len = scalar @{$arr_ref};

  my $format = "%0${len}b";

  for (my $i=0; $i<2**$len; $i++) {
    my @selector = split //, sprintf $format, $i;

    my @curset = ();

    for (my $d=0; $d<$len; $d++) {
      if ($selector[$d]) {
        push @curset, $arr_ref->[$d];
      }
    }
    push @sets, \@curset;
  }
  return \@sets;
}

my @l = ();
for (my $i=0; $i<MAX; $i++) {
  push @l, [];
}

# sieve, find all prime factors
for (my $d=2; $d<@l; $d++) {
  if (@{$l[$d]} == 0) {
    for (my $m=$d; $m<@l; $m+=$d) {
        push @{$l[$m]}, $d;
    } 
  }
}

print Dumper(@l);

my $total = 0;

for (my $i=2; $i<@l; $i++) {
  my @primes = @{$l[$i]};
  my $sets_ref = subsets(\@primes);
  my $nnonprop=0;
  foreach my $subset (@{$sets_ref}) {
    my $nof_elem = scalar @{$subset};
    next if $nof_elem == 0;
    my $sign = ($nof_elem % 2 == 0 ? -1 : 1);

    my $plier = 1;
    foreach my $el (@$subset) {
      $plier *= $el;
    }
    my $n = $i/$plier;
#    print "subset: ", join (", ", @$subset), ": ", $sign, "*", $n, "\n";
    $nnonprop += $sign * $n;
  }
  $total += $i-$nnonprop;
  
  if (int rand(1000) == 0) { 
    print "$i: ", join (", ", @primes), "\n"; 
    print "nof_prop: ", $i-$nnonprop, "\n";
  }

}
 
print $total;

#print Dumper(subsets([1, 10, 5, 2]));


