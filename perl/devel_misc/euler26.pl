use strict;

my $maxrunlength = 0;

sub div {
  use integer;

  my ($a,$b) = @_;
  
  my $pot = 0;
  my $res = '';

  my %rem = ();
  while(1) {
    while ($a<$b) {
      $pot++;
      $a*=10;
    }
    my $d = $a/$b;
    $res .= $d;  
    $a = $a % $b;
    if ($a==0) {
#      substr ($res, -$pot, 0) = '.';
      return "$res E $pot";
    } else {
      if ($rem{$a}) {
        my $runlength = length ($res) - $rem{$a};
        if ($runlength > $maxrunlength) {
          $maxrunlength = $runlength;
          print "$maxrunlength! (@_)\n";
        }
        return "$res E $pot ($runlength)";
      }

      $rem{$a} = length $res;
    }
  }
}

foreach (1..999) {
  print "$_ : ", div(1,$_), "\n";
}
print 





