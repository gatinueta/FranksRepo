use strict;
use constant MAX => 10000;
use bigint;

sub reverse_string {
  my $res = join "", reverse split //, shift;
  $res =~ s/^0+(.)/$1/;
  return $res;
}

sub is_palindromic {
  my @l = split //, shift;
  my $len = @l;
  foreach (0..($len/2)) {
    if ($l[$_] != $l[$len-1-$_]) {
      return 0;
    }
  }

  return 1;
}

my $nlychrel=0;

for (my $i=1; $i<MAX; $i++) {
  my $iter=0;
  my $n = $i;
  do {
    $n = $n + reverse_string $n;
    $iter++;
  } while ($iter<=60 && !is_palindromic($n));
   
  if ($iter > 50) {
    print "$i: $iter ($n)\n"; 
    $nlychrel++;
  }
}

print "nlychrel = $nlychrel\n";



