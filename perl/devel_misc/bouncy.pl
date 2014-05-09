use strict;

sub is_bouncy {
  my $n = shift;
  #print "$n...\n";
  my $lastd;
  my $dir = 0;
  while ($n>0) {
    use integer;
    my $d = $n%10;
    $n = $n/10;

    if (defined($lastd)) {
      my $c = $lastd <=> $d;

      if ($c != 0) {
        if ($dir == 0) {
          $dir = $c;
        } elsif ($c != $dir) {
          #print "testing $d:  dir is now $c, yes\n";
          return 1;
        } 
      }
    }
    $lastd = $d;
  }
  return 0;
}

my $nbouncy = 0;
my $record;
my $backtrack = 0;

for (my $n=0;;$n++) {
  $nbouncy++ if (is_bouncy($n));
  if ( $backtrack or $n%1000 == 1) { 
    my $rel = $nbouncy/$n;
    if ($rel <= 0.99) {
      $record = [ $n, $nbouncy ];
      print "$n: $rel\n";
    } elsif ($backtrack) {
      exit 0;
    } else {
      $n = $record->[0];
      $nbouncy = $record->[1];
      $backtrack = 1;
    }
  }
}



