use strict;

use constant LIMIT => 1000000;

sub rot {
  use integer;
  my $n = shift;

  return ($n%10) * 10**(length($n)-1) + ($n/10);
}

my @isntprime; 

for (my $i=2; $i<LIMIT; $i++) {
  next if ($isntprime[$i]);
  for (my $k=$i*2; $k<LIMIT; $k+=$i) {
    $isntprime[$k] = 1;
  }
}

my $nof_circular = 0;

LOOP:
for (my $i=2; $i<LIMIT; $i++) {
  next LOOP if ($isntprime[$i]);
  next LOOP if ($i>5 and $i !~ /^[1379]*$/); 
  
  my $k=rot($i);
  while ($k != $i) {
    next LOOP if ($isntprime[$k]);
    $k = rot($k);
  }
  print "$i is cp\n";
  $nof_circular++;
}

print "$nof_circular\n";



