use strict;

use constant MAX => 25000000;

my $nof_barely_acute = 0;

for (my $sum=1; $sum <= MAX; $sum++) {
  print "$nof_barely_acute\n" if $sum%1000 == 0;
  for (my $a=0; $a <= $sum/2; $a++) {
    my $b = $sum-$a;

#    print "$a, $b?\n";
    my $cq = $a*$a+$b*$b-1;
    my $c = int (sqrt ($cq) + .5);
    if ($a+$b+$c <= MAX && $c*$c == $cq) {
      $nof_barely_acute++;
#      print "$a $b $c\n";
    }
  }
}

print "$nof_barely_acute\n";
