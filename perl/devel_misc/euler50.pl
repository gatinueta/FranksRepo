my @primes = ();
my %notprime = ();

sub sieve {
  my $limit = shift;
 
  for (my $i=2; $i<$limit; $i++) {
    unless ($notprime{$i}) {
      for (my $j=2; $i*$j<$limit; $j++) {
        $notprime{$i*$j} = 1;
      }
    }
  }
  for (my $i=2; $i<$limit; $i++) {
    push @primes, $i unless ($notprime{$i});
  }
}



my $limit = 1000000;
sieve($limit);

OUTER: for (my $ncons = 2; ; $ncons++) {
  INNER: for (my $i=0;; $i++) {
    my $sum=0;
    foreach my $j (0..$ncons-1) {
      $sum += $primes[$i+$j];
    }
    next OUTER if ($sum>$limit);
    if (!$notprime{$sum}) {
      print "$sum ($ncons)\n";
      last INNER;
    }
  }
#  next OUTER if ($i==@primes-$ncons); 
}



