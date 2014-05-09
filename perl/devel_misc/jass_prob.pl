
use constant NOF_SUITS => 4;
use constant NOF_VALUES => 9;
use constant NOF_PLAYERS => 4;

use bigrat; 
sub factorial { 
  my $n = shift; 
  my $res = 1; 
  for (2..$n) { 
    $res *= $_; 
  } 
  return $res; 
} 

sub deep 
{ 
  my ($n, $k) = @_;
  print "n=$n, k=$k\n";
  $result = factorial($n)/factorial($k)/factorial($n-$k);

  print "got it.\n";

  return $result;
} 

sub blatt_prob { 
  my $n = shift; 
  return deep(36-$n, 9-$n) * (9-$n+1) * 4 / deep(36, 9); 
} 

#my $x = blatt_prob $ARGV[0];


my $x;

sub c1 {
  $x = deep(&NOF_SUITS*(&NOF_VALUES-1), &NOF_VALUES-&NOF_SUITS) / deep(36,9);
}

sub c2 {
  $x = deep(&NOF_SUITS*(&NOF_VALUES-1), &NOF_VALUES-&NOF_SUITS) / deep(&NOF_SUITS * &NOF_VALUES, &NOF_SUITS * &NOF_VALUES / &NOF_PLAYERS);
}


c1;
c1;
c2;
c2;

print "$x = ", $x->numify(), "\n";


