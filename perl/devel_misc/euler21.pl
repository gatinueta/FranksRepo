use strict;
use List::Util 'reduce';

sub divisors {
  my $n = shift;
  my @divs = ();

  for (my $i=1; $i<=$n/2; $i++) {
    push @divs, $i if $n%$i==0;
  }
  return @divs;
}

my %dsum = ();

sub d {
  my $n = shift;
  if (!exists $dsum{$n}) {
    $dsum{$n} = reduce { $a+$b } divisors($n);
  }
  return $dsum{$n} // 0;
}


my %amic = ();

for (my $i=1; $i<10000; $i++) {
  my $v = d($i);
  #print "$i: $v\n";
  #print "$v: ", d($v), "\n";
  if ($i < $v and d($v) == $i) {
    print "$i, $v\n";
    $amic{$v} = 1;
    $amic{$i} = 1;
  }
}

print reduce { $b<10000 ? $a+$b : $a } (keys %amic);



