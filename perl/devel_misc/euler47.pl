my @primes = ();

sub sieve {
  my $limit = shift;
  my %notprime = ();
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

sub factors {
  my $n = shift;
  my @factors = ();
  for (my $i=0; $n>1 and $i<@primes; $i++) {
    while ($n % $primes[$i] == 0) {
      push @factors, $primes[$i];
      $n /= $primes[$i];
    }
  }
  return @factors;
}

my $limit = 1000000;
sieve($limit);

sub nof_distinct {
  my ($last,$n) = (1,0);
  foreach (@_) {
    if ($_ != $last) {
      $n++;
      $last = $_;
    }
  }
  return $n;
}

for (my $n=2; $n<$limit*$limit; $n++) {
  my $nf = nof_distinct(factors($n));
  if ($nf==4) {
    $nc++;
    print "$n = ", join ('*', factors($n)), "($nc)\n";
  } else {
    $nc=0;
  }
  last if ($nc==4);
}


